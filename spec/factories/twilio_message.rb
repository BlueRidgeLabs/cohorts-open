# frozen_string_literal: true
FactoryGirl.define do
  factory :twilio_message do
    message_sid 'ABC123'
    account_sid 'DEF789'
    from { ENV['TWILIO_NUMBER'] }
    to { Faker::PhoneNumber.phone_number }
    body { Faker::Hipster.word }
    status 'received'
  end
end
