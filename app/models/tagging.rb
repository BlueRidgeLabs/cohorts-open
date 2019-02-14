# frozen_string_literal: true
class Tagging < ActiveRecord::Base
  has_paper_trail
  belongs_to :tag, counter_cache: true
  belongs_to :taggable, polymorphic: true, touch: true
  after_destroy :destroy_orphaned_tag
  before_create  :increment_counter
  before_destroy :decrement_counter
  after_commit :reindex_taggable
  validates_presence_of :tag_id

  attr_accessor :name
  validates_uniqueness_of :tag_id, scope: [:taggable_id, :taggable_type]

  private

    def destroy_orphaned_tag
      tag.destroy if Tagging.where(tag: tag).count.zero? && LandingPage.where(tag: tag).none?
    end

    # increments the right classifiable counter for the right taxonomy
    def increment_counter
      taggable_type.constantize.increment_counter('tag_count_cache', taggable_id)
    end

    # decrements the right classifiable counter for the right taxonomy
    def decrement_counter
      taggable_type.constantize.decrement_counter('tag_count_cache', taggable_id)
    end

    def reindex_taggable
      taggable.reindex if taggable.respond_to?(:reindex)
    end
end
