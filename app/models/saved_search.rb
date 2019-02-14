# frozen_string_literal: true
class SavedSearch < ActiveRecord::Base
  validates :label, presence: true, uniqueness: true
  validates :query, presence: true, uniqueness: true
end
