# frozen_string_literal: true
class StaticPage < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :history

  validates :title, presence: true
  validates :body, presence: true

  def should_generate_new_friendly_id?
    title_changed?
  end
end
