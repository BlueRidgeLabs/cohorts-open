# frozen_string_literal: true
class Admin::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout 'admin'

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone_number])
    end

    # rubocop:disable Lint/UnusedMethodArgument
    def after_update_path_for(resource)
      admin_root_path
    end
  # rubocop:enable Lint/UnusedMethodArgument
end
