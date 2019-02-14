# frozen_string_literal: true
class Admin::TwoFactorAuthenticationController < Devise::TwoFactorAuthenticationController
  layout 'sessions'
end
