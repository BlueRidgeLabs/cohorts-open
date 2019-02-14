# frozen_string_literal: true
class Client < ActiveRecord::Base
  has_many :engagements
  has_many :research_sessions, through: :engagements

  def checklists
    Checklist.find(checklist_ids)
  end

  def eligibility_criteria
    SavedSearch.where(id: saved_search_ids)
  end

  def eligible_search_query
    eligibility_criteria.map(&:query).join(' ')
  end
end
