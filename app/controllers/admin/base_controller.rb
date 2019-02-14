# frozen_string_literal: true
class Admin::BaseController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_paper_trail_whodunnit
  after_action :flash_to_headers

  layout 'admin'

  def user_needed
    unless current_admin_user
      render json: { 'error' => 'authentication error' }, status: 401
    end
  end

  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message if flash_message
    response.headers['X-Message-Type'] = flash_type.to_s if flash_type
    flash.discard # don't want the flash to appear when you reload page
  end

  private

    def flash_message
      [:error, :warning, :notice].each do |type|
        return flash[type] unless flash[type].blank?
      end
      nil
    end

    def flash_type
      [:error, :warning, :notice].each do |type|
        return type unless flash[type].blank?
      end
      nil
    end
end
