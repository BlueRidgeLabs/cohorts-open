# frozen_string_literal: true
require 'rails_helper'

describe 'People' do
  describe 'index' do
    let!(:people) { create_list(:person, 5) }
    let!(:tag) { create(:tag, name: 'suave') }
    let!(:tagging) { create(:tagging, tag: tag, taggable: people.first) }
    let!(:question) { create(:question, text: 'Do you have a cat?') }
    context 'with no user logged in' do
      it 'should redirect to the login page' do
        visit admin_people_path
        expect(page).to have_current_path new_admin_user_session_path
      end
    end

    context 'with an admin logged in' do
      before do
        login_as(create(:user))
        visit admin_people_path
      end

      it 'should allow importing a CSV list of people', js: true do
        page.execute_script("$('input[type=file]').show()")
        # this is to hide an overlapping element.
        page.execute_script("$('body > div.ui.top.fixed.menu').hide()")
        attach_file 'file', 'spec/support/test_import.csv'
        page.execute_script("$('form#import-csv-form').submit()")
        expect(page).to have_content 'CSV imported successfully'
        # expect(page).to have_content 'Bob Bill'
        # expect(Person.find_by(first_name: 'Bob', last_name: 'Bill').answers.count.positive?).to be true
      end

      it 'should hide member info when Privacy Mode is on', js: true do
        find('#privacy-mode-toggle').trigger('click')

        people.each do |person|
          expect(page).to have_content person.initials
          expect(page).to have_content 'hidden'

          expect(page).to_not have_content person.full_name
          expect(page).to_not have_content person.email_address
          expect(page).to_not have_content person.phone_number
        end
      end

      # TODO: These are broken because of pagination (and markup changes)
      # it 'should show a list of people' do
      #   people.each do |person|
      #     expect(page).to have_content(person.full_name)
      #     expect(page).to have_content(person.email_address)
      #   end
      # end

      # it 'should allow visiting a persons show page' do
      #   expect(page).to have_link people.first.full_name
      #   find("#person-#{people.first.id}").first(:link, people.first.full_name).click
      #   expect(page).to have_current_path admin_person_path(people.first)
      # end

      # it 'should allow editing a person' do
      #   expect(page).to have_link 'Edit'
      #   find("#person-#{people.first.id}").first(:link, 'Edit').click
      #   expect(page).to have_current_path edit_admin_person_path(people.first)
      # end

      # it 'should allow deactivating a person', js: true do
      #   expect(page).to have_content 'Deactivate'
      #   accept_confirm_from do
      #     find("#person-#{people.first.id}").first(:link, 'Deactivate').click
      #   end
      #   expect(page).to have_current_path admin_people_path
      #   expect(page).to have_content "#{people.first.full_name} deactivated"
      # end

      # it 'should allow deleting a person', js: true do
      #   expect(page).to have_content 'Delete'
      #   accept_confirm_from do
      #     find("#person-#{people.first.id}").first(:link, 'Delete').click
      #   end
      #   expect(page).to have_current_path admin_people_path
      #   expect(page).to have_content "#{people.first.full_name} deleted"
      # end
    end
  end
  describe 'show' do
    let!(:person) { create(:person) }
    let!(:suave_tag) { create(:tag, name: 'suave') }
    let!(:existing_tag) { create(:tag) }
    let!(:tagging) { create(:tagging, tag: suave_tag, taggable: person) }
    let!(:existing_note) { create(:comment, commentable: person) }
    let!(:existing_contact) { create(:contact, contactable: person) }
    let!(:gift_card) { create(:gift_card, person: person) }
    let!(:questions) { create_list(:question, 3) }
    let!(:answer1) { create(:answer, question: questions.first, person: person) }
    let!(:answer2) { create(:answer, question: questions.second, person: person) }
    context 'with no user logged in' do
      it 'should redirect to the login page' do
        visit admin_person_path(person)
        expect(page).to have_current_path new_admin_user_session_path
      end
    end

    context 'with an admin logged in' do
      before do
        login_as(create(:user))
        visit admin_person_path(person)
      end

      it 'should display the persons details' do
        expect(page).to have_content person.full_name
        expect(page).to have_content person.verified
        expect(page).to have_content person.address_fields_to_sentence
        expect(page).to have_content 'suave'
      end

      it 'should have a map of the persons location' do
        expect(page).to have_selector 'img.google-map'
      end

      it 'should allow adding an existing tag to the person', js: true, retry: 6 do
        find('#add-tag-field .dropdown.icon').trigger('click')
        expect(page).to have_content existing_tag.name
        within '#add-tag-field' do
          find('.menu .item', text: existing_tag.name).trigger('click')
          find('.submit.button').trigger('click')
        end
        within('#tag-list') do
          expect(page).to have_content existing_tag.name
        end
      end

      it 'should allow adding a new tag to the person', js: true do
        page.execute_script("$('#add-tag-field .ui.dropdown').dropdown('set selected', 'awesome')")
        within('#tag-list') do
          expect(page).to have_content 'awesome'
        end
        expect(Tag.last.name).to eq 'awesome'
      end

      it 'should display existing contact history' do
        expect(page).to have_content existing_contact.notes
      end

      it 'should allow adding of contact history to the person', js: true do
        contact_notes = Faker::Hipster.sentence
        fill_in 'comment_content', with: contact_notes
        page.execute_script("$('#contact-check').trigger('click')")
        select('email', from: 'comment_contact_type', visible: false)
        find('#contact-submit').trigger('click')
        expect(page).to have_content contact_notes
      end

      it 'should render errors for comments with no notes', js: true do
        find('#contact-submit').trigger('click')
        expect(page).to have_css('p#comment-error')
      end

      it 'should not render errors for proper comments', js: true do
        contact_notes = Faker::Hipster.sentence
        fill_in 'comment_content', with: contact_notes
        find('#contact-submit').trigger('click')
        expect(page).to have_no_css('p#comment-error')
      end

      it 'should render errors for contacts with no contact type', js: true do
        page.execute_script("$('#contact-check').trigger('click')")
        find('#contact-submit').trigger('click')
        expect(page).to have_css('p#contact-error')
      end

      it 'should not render errors for contacts with a type selected', js: true do
        page.execute_script("$('#contact-check').trigger('click')")
        select('email', from: 'comment_contact_type', visible: false)
        find('#contact-submit').trigger('click')
        expect(page).to have_no_css('p#contact-error')
      end

      it 'should display existing notes' do
        expect(page).to have_content existing_note.content
      end

      it 'should display gift cards already sent to the person' do
        expect(page).to have_content gift_card.gift_card_number
        expect(page).to have_content gift_card.expiration_date
      end

      it 'should allow adding a new gift card', js: true do
        gift_card = build(:gift_card, person: person)
        fill_in 'gift_card_batch_id', with: gift_card.batch_id
        fill_in 'gift_card_gift_card_number', with: gift_card.gift_card_number
        fill_in 'gift_card_expiration_date', with: gift_card.expiration_date
        fill_in 'gift_card_amount', with: '20.00'
        click_on 'Add Gift Card'
        expect(page).to have_content gift_card.gift_card_number
        expect(page).to have_content gift_card.batch_id
        expect(page).to have_content '$20'
      end

      it 'should display the questions answered by the person' do
        expect(page).to have_content questions.first.text
        expect(page).to have_content answer1.value
        expect(page).to have_content questions.second.text
        expect(page).to have_content answer2.value
        expect(page).to_not have_content questions.third.text
      end

      it 'should hide details when Privacy Mode is on', js: true do
        find('#privacy-mode-toggle').trigger('click')

        expect(page).to have_content person.initials
        expect(page).to have_content 'hidden'

        expect(page).to_not have_content person.full_name
        expect(page).to_not have_content person.email_address
        expect(page).to_not have_content person.phone_number
        expect(page).to_not have_content person.address_fields_to_sentence
      end
    end
  end
  describe 'edit' do
    let!(:person) { create(:person) }
    context 'with no user logged in' do
      it 'should redirect to the login page' do
        visit edit_admin_person_path(person)
        expect(page).to have_current_path new_admin_user_session_path
      end
    end

    context 'with an admin logged in' do
      before do
        login_as(create(:user))
        visit edit_admin_person_path(person)
      end

      it 'should allow editing a person' do
        expect(find_field('First name').value).to eq person.first_name
        expect(find_field('Last name').value).to eq person.last_name
        expect(find_field('Phone number').value).to eq person.phone_number
        fill_in 'Phone number', with: '+13216549870'
        fill_in 'Postal code', with: '87614'
        click_on 'Update Member'
        expect(page).to have_content 'Member was successfully updated'
        expect(page).to have_content '+13216549870'
        expect(page).to have_content '87614'
      end
    end
  end
end
