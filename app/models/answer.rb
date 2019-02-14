# frozen_string_literal: true
class Answer < ActiveRecord::Base
  belongs_to :question, required: true, counter_cache: true
  delegate :form, to: :question
  belongs_to :person, required: true
  belongs_to :submission
  validates :value, presence: true
  after_commit :reindex_person

  private

    def reindex_person
      person.reindex
    end
end
