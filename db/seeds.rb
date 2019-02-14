# Make some dummy people
require 'faker'
if Rails.env.development?
  125.times do 
    Person.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email_address: Faker::Internet.unique.email,
    address_1:Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    postal_code: Faker::Address.postcode,
    geography_id: '',
    primary_device_id: 1,
    primary_device_description: Faker::Pokemon.name,
    secondary_device_id: 2,
    secondary_device_description: Faker::Pokemon.name,
    primary_connection_id: 1,
    primary_connection_description: Faker::Company.name,
    phone_number: Faker::PhoneNumber.phone_number,
    participation_type: Faker::Color.color_name,
    preferred_contact_method: Faker::Company.name,
    token: Faker::Company.name,
    signup_at: Faker::Date.between(100.days.ago,Time.now),
    signup_form_id:Faker::Number.number(4),
    tag_count_cache: Faker::Number.number(2),
    last_contacted: Faker::Date.between(50.days.ago,Time.now)
    )
  end
end


User.create(
  email: 'cohorts@example.com',
  password: 'foobar123',
  password_confirmation: 'foobar123',
  approved: true,
  name: 'Joe User',
  phone_number: '555-555-5555'
)
