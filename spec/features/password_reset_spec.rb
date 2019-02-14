# frozen_string_literal: true
require 'rails_helper'

describe 'member password recovery' do
  attr_accessor :current_email_address

  describe 'forgotten password reset' do
    it 'should be able to reset password through forgotten password email' do
      member = FactoryGirl.create(:user)
      visit '/admin/users/sign_in'
      click_on 'Forgot your password?'
      fill_in 'Email', with: member.email
      click_on 'Send me reset password instructions'

      self.current_email_address = member.email
      expect(unread_emails_for(member.email)).to be_present
      open_email(member.email)
      click_first_link_in_email
      expect(page).to have_content('Change your password')
      fill_in 'New password', with: 'new_password'
      fill_in 'Confirm new password', with: 'new_password'

      click_on 'Change my password'
      visit admin_root_path
      click_on 'Sign out'

      fill_in 'Email', with: member.email
      fill_in 'Password', with: 'new_password'
      click_on 'Sign in'
      expect(page).to have_content('Sign out')
    end
  end
end
