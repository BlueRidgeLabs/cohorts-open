# frozen_string_literal: true
FactoryGirl.define do
  factory :contact do
    contact_type { Faker::Hipster.sentence }
    notes 'Attempted to contact user'
    contact_time { Faker::Time.backward(100, :evening) }
    user_id 1
    contactable_type 'Person'
  end
end
