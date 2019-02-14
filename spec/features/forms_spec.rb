# frozen_string_literal: true
require 'rails_helper'

describe 'Forms' do
  context 'with no user logged in' do
    it 'should redirect to the login page' do
      visit admin_forms_path
      expect(page).to have_current_path new_admin_user_session_path
    end
  end

  context 'with an admin logged in' do
    let!(:forms) { create_list(:form, 4) }
    before do
      login_as(create(:user))
      visit admin_forms_path
    end

    it 'should display all four forms' do
      forms.each do |form|
        expect(page).to have_content form.name
        expect(page).to have_content form.description
      end
    end

    it 'should allow changing the twilio keyword' do
      form_to_update = forms[rand(4)]
      within "#form-#{form_to_update.id}" do
        find('a.ui.left.attached.icon.button').click
      end
      fill_in 'Twilio keyword', with: 'whatever'
      click_on 'Update'
      expect(page).to have_content "\"#{form_to_update.name}\" updated"
      expect(page).to have_content form_to_update.description
    end

    it 'should allow hiding forms not related to Cohorts' do
      form_to_hide = forms[rand(4)]
      within "#form-#{form_to_hide.id}" do
        find('a.ui.left.attached.icon.button').click
      end
      check 'form_hidden'
      click_on 'Update'
      expect(page).to have_content "\"#{form_to_hide.name}\" updated"
      expect(page).to_not have_content form_to_hide.description
    end
  end
end
