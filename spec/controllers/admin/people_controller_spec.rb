# frozen_string_literal: true
RSpec.describe Admin::PeopleController do
  describe 'POST create' do
    let!(:mapping) do
      { 'Field1'=>'first_name', 'Field2'=>'last_name', 'Field4'=>'email_address', 'Field212'=>'preferred_contact_method', 'Field1418'=>'phone_number' }
    end
    let!(:form) { create(:form, hash_id: 'x1hf8igs0ukwq5y', mapping: mapping) }

    it 'records new members from Wufoo' do
      post :create, STUB_WUFOO_SIGNUP_PARAMS
      expect(Person.count).to eq 1
      expect(Person.first.full_name).to eq 'Bob Tester'
      expect(Person.first.email_address).to eq 'bobtester@yahoo.com'
      expect(Person.first.phone_number).to eq '+13189885295'
    end
  end
end
