# frozen_string_literal: true
FactoryGirl.define do
  factory :trait, class: Trait do
    name { Faker::Hipster.word }
    after(:build) do |trait|
      trait.name += "-#{Faker::Hipster.word}" until trait.valid?
    end
  end

  factory :person_trait, class: PersonTrait do
    before(:create) do |person_trait|
      person_trait.person = FactoryGirl.create(:person)
      person_trait.trait = FactoryGirl.create(:trait)
      person_trait.value = Faker::Hipster.word
    end
  end
end
