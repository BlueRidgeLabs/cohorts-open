# frozen_string_literal: true
FactoryGirl.define do
  factory :saved_search do
    label { Faker::Hipster.sentence }
    query { "tag:(\"#{Faker::Hipster.word}\")" }
  end
end
