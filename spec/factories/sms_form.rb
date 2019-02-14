# frozen_string_literal: true
FactoryGirl.define do
  factory :sms_form do
    values {}
    form
    phone_number { Faker::PhoneNumber.phone_number }
    field_counter 0
  end
end
