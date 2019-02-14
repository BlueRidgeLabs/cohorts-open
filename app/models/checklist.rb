# frozen_string_literal: true
class Checklist < ActiveRecord::Base
  has_many :session_checklists
  has_many :research_sessions, through: :session_checklists

  def clients
    Client.where('? = ANY(checklist_ids)', id)
  end

  def engagements
    Engagement.where('? = ANY(checklist_ids)', id)
  end

  def checklist_count
    session_checklists.count
  end
end
