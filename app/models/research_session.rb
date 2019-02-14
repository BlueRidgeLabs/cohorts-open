# frozen_string_literal: true
class ResearchSession < ActiveRecord::Base
  belongs_to :engagement, required: true
  delegate :client, to: :engagement
  has_many :session_invites
  has_many :people, through: :session_invites
  has_many :session_checklists
  has_many :checklists, through: :session_checklists
  after_create :create_checklists

  private

    def create_checklists
      engagement.checklists.each do |checklist|
        SessionChecklist.create(research_session: self, checklist: checklist)
      end
    end
end
