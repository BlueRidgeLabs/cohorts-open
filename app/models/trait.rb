# frozen_string_literal: true
class Trait < ActiveRecord::Base
  has_many :person_traits, dependent: :destroy
  has_many :people, through: :person_traits
  validates :name, presence: true, uniqueness: true
  before_save { self.name = name.titlecase }

  def trait_count
    person_traits_count
  end
end
