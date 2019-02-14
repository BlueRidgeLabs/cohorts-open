# frozen_string_literal: true
class PersonTrait < ActiveRecord::Base
  self.primary_keys = :person_id, :trait_id
  belongs_to :person
  belongs_to :trait, counter_cache: true
  validates_uniqueness_of :person_id, scope: :trait_id
  before_save { self.value = value.downcase }
  after_destroy -> { trait.delete }, if: -> { trait.person_traits.count.zero? }
  after_commit :reindex_person

  private

    def reindex_person
      person.reindex
    end
end
