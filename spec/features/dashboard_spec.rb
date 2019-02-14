# frozen_string_literal: true
require 'rails_helper'

describe 'Dashboard' do
  context 'with no user logged in' do
    it 'should redirect to the login page' do
      visit admin_root_path
      expect(page).to have_current_path new_admin_user_session_path
    end
  end

  context 'with an admin logged in' do
    let!(:people) { create_list(:person, 6) }
    let!(:submission) { create(:submission, person: nil) }
    let!(:popular_tag) { create(:tag, name: 'suave') }
    let!(:taggings) { create_list(:tagging, 3, tag_id: popular_tag.id) }
    before do
      login_with_admin_user
      visit admin_root_path
    end

    it 'should allow logging out' do
      expect(page).to have_content 'Sign out'
      find('#account-link').click
      click_on 'Sign out'
      expect(page).to have_current_path new_admin_user_session_path
    end

    it 'should show the five most recently created people' do
      expect(page).to have_content people.last.full_name
      expect(page).to have_content people.last.address_fields_to_sentence
      unless (people - [people.first]).map(&:full_name).include? people.first.full_name
        expect(page).to_not have_content people.first.full_name
      end
      expect(page).to have_content '9 signups'
    end

    it 'should hide member info when Privacy Mode is on', js: true do
      find('#privacy-mode-toggle').trigger('click')

      people.last(2).concat(taggings.map(&:taggable)).each do |person|
        expect(page).to have_content person.initials
        expect(page).to have_content 'hidden'

        expect(page).to_not have_content person.full_name
        expect(page).to_not have_content person.address_fields_to_sentence
      end
    end

    it 'should show any unmatched submissions' do
      expect(page).to have_link "Submission 1"
      expect(page).to have_content '1 form submission in the last week'
    end

    it 'should show popular tags' do
      expect(page).to have_content 'suave'
    end
  end
end
