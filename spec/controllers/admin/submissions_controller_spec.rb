# frozen_string_literal: true
RSpec.describe Admin::SubmissionsController do
  describe 'POST create' do
    let!(:person) { create(:person) }
    let!(:form) { create(:form, hash_id: 'k12z8n2o1gmaduv') }

    it 'records submissions from Wufoo and matches with an existing member by email address' do
      person.update(email_address: 'fake.brian.fentan@yahoo.com')
      post :create, STUB_WUFOO_SUBMISSION_PARAMS
      expect(Submission.count).to eq 1
      expect(Submission.first.person).to eq person
    end

    it 'records submissions from Wufoo and matches with an existing member by phone number' do
      person.update(phone_number: '+19224693733')
      post :create, STUB_WUFOO_SUBMISSION_PARAMS
      expect(Submission.count).to eq 1
      expect(Submission.first.person).to eq person
    end

    it 'pulls submissions from Wufoo when manually matched' do
      sign_in create(:user)
      post :create, { submission: { entry_id: '9', person_id: person.id, form_id: form.id } }
      expect(Submission.count).to eq 1
      expect(Submission.first.person).to eq person
    end
  end
end
