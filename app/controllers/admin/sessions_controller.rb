# frozen_string_literal: true
class Admin::SessionsController < Devise::SessionsController
  layout 'sessions'

  private

    # rubocop:disable Lint/UnusedMethodArgument
    def after_sign_out_path_for(resource_or_scope)
      admin_root_path
    end
  # rubocop:enable Lint/UnusedMethodArgument
end
