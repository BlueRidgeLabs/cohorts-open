# frozen_string_literal: true
class MandrillController < ApplicationController
  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV['MANDRILL_WEBHOOK_KEY']
  skip_before_action :verify_authenticity_token

  def handle_inbound(event_payload)
    Rails.logger.info("[Mandrill] Received inbound email to admin@adhocteam.us:\n#{event_payload}")
    head :ok
  end

  def outbound
    params[:to].each do |to|
      EmailMessage.create(to: to, from: ENV['MAILER_SENDER'], subject: message_params[:subject], body: message_params[:body])
    end
    flash[:notice] = 'Messages sent successfully!'
    redirect_to :back
  end

  private

    def message_params
      params.require(:email_message).permit(:subject, :body)
    end
end
