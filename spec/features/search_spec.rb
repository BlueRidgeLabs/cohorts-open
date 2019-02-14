# frozen_string_literal: true
require 'rails_helper'

describe 'Search' do
  describe 'from the menubar' do
    let!(:person) { create(:person) }
    let!(:people) { create_list(:person, 5) }
    before do
      login_as(create(:user))
      visit admin_root_path
    end

    it 'should allow searching by first name', js: true do
      fill_in 'q', with: person.first_name
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.email_address
      expect(page).to have_content person.phone_number
      people.each do |other_person|
        unless other_person.first_name == person.first_name
          expect(page).to_not have_content other_person.full_name
        end
      end
    end

    it 'should allow searching by last name', js: true do
      fill_in 'q', with: person.last_name
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.email_address
      expect(page).to have_content person.phone_number
      people.each do |other_person|
        unless other_person.last_name == person.last_name
          expect(page).to_not have_content other_person.full_name
        end
      end
    end

    it 'should allow searching by full name', js: true do
      fill_in 'q', with: person.full_name
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.email_address
      expect(page).to have_content person.phone_number
      people.each do |other_person|
        unless other_person.full_name == person.full_name
          expect(page).to_not have_content other_person.full_name
        end
      end
    end

    it 'should allow searching by email', js: true do
      fill_in 'q', with: person.email_address
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.email_address
      expect(page).to have_content person.phone_number
      people.each do |other_person|
        unless other_person.email_address == person.email_address
          expect(page).to_not have_content other_person.full_name
        end
      end
    end

    it 'should allow searching by phone number', js: true do
      fill_in 'q', with: person.phone_number
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.email_address
      expect(page).to have_content person.phone_number
      people.each do |other_person|
        unless other_person.phone_number == person.phone_number
          expect(page).to_not have_content other_person.full_name
        end
      end
    end
  end
  describe 'from the search page' do
    let!(:people) { create_list(:person, 5) }
    let!(:tags) { create_list(:tag, 5) }
    let!(:taggings) do
      tags.each do |tag|
        @person = people[rand(5)]
        create(:tagging, tag: tag, taggable: @person)
        @person.tags.append(tag)
      end
    end
    let!(:trait) { create(:trait) }
    let!(:person_trait) { create(:person_trait, trait: trait, person: people[rand(5)]) }

    context 'with no user logged in' do
      it 'should redirect to the login page' do
        visit admin_people_path
        expect(page).to have_current_path new_admin_user_session_path
      end
    end

    context 'with an admin logged in' do
      before do
        question = create(:question)
        people.map do |person|
          create(:answer, question: question, person: person) if [true, false].sample
        end
        login_as(create(:user))
        visit admin_people_path
        # find('#filter-button').click
        find(:css, '#filter-button').trigger('click')
      end

      it 'should allow searching by full name', js: true do
        person = people[rand(4)]
        fill_in 'all', with: person.full_name
        click_on 'Search'
        expect(page).to have_content person.full_name
        expect(page).to have_content person.email_address
        expect(page).to have_content person.phone_number
        people.reject { |p| p == person }.each do |other_person|
          unless other_person.full_name == person.full_name
            expect(page).to_not have_content other_person.full_name
          end
        end
      end

      it 'should allow searching by email', js: true do
        person = people[rand(4)]
        fill_in 'all', with: person.email_address
        click_on 'Search'
        expect(page).to have_content person.full_name
        expect(page).to have_content person.email_address
        expect(page).to have_content person.phone_number
        people.reject { |p| p == person }.each do |other_person|
          unless other_person.email_address == person.email_address
            expect(page).to_not have_content other_person.full_name
          end
        end
      end

      it 'should allow searching by phone number', js: true do
        person = people[rand(4)]
        fill_in 'all', with: person.phone_number
        click_on 'Search'
        expect(page).to have_content person.full_name
        expect(page).to have_content person.email_address
        expect(page).to have_content person.phone_number
        people.reject { |p| p == person }.each do |other_person|
          unless other_person.phone_number == person.phone_number
            expect(page).to_not have_content other_person.full_name
          end
        end
      end

      it 'should allow searching by address 1', js: true do
        person = people[rand(4)]
        fill_in 'all', with: person.address_1
        click_on 'Search'
        expect(page).to have_content person.full_name
        expect(page).to have_content person.email_address
        expect(page).to have_content person.phone_number
        people.reject { |p| p == person }.each do |other_person|
          unless other_person.address_1 == person.address_1
            expect(page).to_not have_content other_person.full_name
          end
        end
      end

      it 'should allow filtering by a single tag', js: true do
        tag = tags[rand(4)]
        select_from_dropdown tag.name, from: 'has_tags'
        click_on 'Search'
        people.each do |person|
          if person.tags.include? tag
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      it 'should allow filtering by multiple tags', js: true do
        tag1 = tags[rand(4)]
        tag2 = (tags - [tag1])[rand(3)]
        select_from_dropdown tag1.name, from: 'has_tags'
        select_from_dropdown tag2.name, from: 'has_tags'
        click_on 'Search'
        people.each do |person|
          if person.tags.include?(tag1) || person.tags.include?(tag2)
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      it 'should allow excluding by trait', js: true do
        select_from_dropdown trait.name, from: 'does_not_have_trait'
        click_on 'Search'
        people.each do |person|
          if person.traits.include?(trait)
            expect(page).to_not have_content person.full_name
          else
            expect(page).to have_content person.full_name
          end
        end
      end

      it 'should allow including by trait', js: true do
        select_from_dropdown trait.name, from: 'has_trait'
        click_on 'Search'
        people.each do |person|
          if person.traits.include?(trait)
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      context 'when there are questions and answers in the system' do
        before do
          allow_any_instance_of(Form).to receive(:create_questions)
        end

        it 'should allow filtering by whether a person has answered a specific question', js: true do
          @question = Question.first
          select_from_dropdown @question.text, from: 'question'
          click_on 'Search'
          people.each do |person|
            if person.questions.include? @question
              expect(page).to have_content person.full_name
            else
              expect(page).to_not have_content person.full_name
            end
          end
        end
      end

      it 'should allow saving a search', js: true do
        person = people[rand(4)]
        fill_in 'all', with: person.first_name
        click_on 'Search'
        find('#save-search-button').trigger('click')
        fill_in 'Label', with: "People named #{person.first_name}"
        click_on 'save-search-submit-button'
        expect(page).to have_content "People named #{person.first_name}"
      end

      it 'should allow exporting a CSV of results', js: true do
        # this is to hide an overlapping element.
        page.execute_script("$('body > div.ui.top.fixed.menu').hide()")
        click_on 'Export CSV'
        expect(page.response_headers['Content-Disposition']).to include 'attachment'
        expect(page.response_headers['Content-Disposition']).to include 'csv'
      end
    end
  end
end
