# frozen_string_literal: true
class SessionChecklist < ActiveRecord::Base
  belongs_to :research_session, required: true
  belongs_to :checklist, required: true
  after_create :initialize_state

  private

    def initialize_state
      self.state = {}
      checklist.items.each do |item|
        state[item] = false
      end
      save
    end
end
