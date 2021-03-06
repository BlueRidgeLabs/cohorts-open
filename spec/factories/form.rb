# frozen_string_literal: true
FactoryGirl.define do
  factory :form do
    hash_id { Faker::Internet.password(15, 15) }
    name { Faker::Hipster.sentence }
    description { Faker::Hipster.paragraph }
    url { Faker::Hipster.words(4).join('-') }
    hidden false
    created_on { Faker::Time.between(1.week.ago, 1.day.ago) }
    last_update { Faker::Time.between(1.day.ago, Time.zone.today) }
    twilio_keyword { Faker::Hipster.word }
  end
end
