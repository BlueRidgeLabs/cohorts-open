# frozen_string_literal: true
class Engagement < ActiveRecord::Base
  belongs_to :client, required: true
  has_many :research_sessions
  has_many :people, through: :research_sessions
  serialize :search_query, Hash
  after_save :create_additional_checklists, if: -> { checklist_ids_changed? }

  scope :recent, (-> { where('end_date > ?', Time.zone.now - 2.weeks) })

  def checklists
    Checklist.find(checklist_ids)
  end

  def eligibility_criteria
    SavedSearch.where(id: saved_search_ids)
  end

  def eligible_search_query
    queries = [client.eligible_search_query]
    queries.push(eligibility_criteria.map(&:query).join(' ')) if eligibility_criteria.any?
    queries.join(' ')
  end

  def eligible_members(filter: nil)
    query = eligible_search_query
    query = query + ' ' + filter if filter
    search_query = {
      query: {
        query_string: {
          query: query.downcase,
          default_operator: 'AND'
        }
      },
      order: { signup_at: :desc }
    }
    Person.search search_query
  end

  private

    def create_additional_checklists
      checklists.each do |checklist|
        research_sessions.each do |session|
          SessionChecklist.find_or_create_by(research_session: session, checklist: checklist)
        end
      end
    end
end
