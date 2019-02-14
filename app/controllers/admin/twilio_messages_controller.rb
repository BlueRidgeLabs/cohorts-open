# frozen_string_literal: true
require 'twilio-ruby'
require 'csv'
class Admin::TwilioMessagesController < Admin::BaseController
  include GsmHelper

  def create
    params[:to].each do |to|
      TwilioMessage.create(
        user: current_admin_user,
        person: Person.find_by(phone_number: to),
        from: ENV['TWILIO_NUMBER'],
        to: to,
        body: twilio_message_params[:body],
        date_sent: Time.zone.now
      )
      SMS.send(to, twilio_message_params[:body])
    end
    respond_to do |format|
      format.html do
        flash[:notice] = 'SMS messages sent!'
        redirect_to :back
      end
      format.js {}
    end
  end

  private

    def find_sender
      @from = current_admin_user.oauth_provider ? current_admin_user.email_address : ENV['MAILER_SENDER']
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def twilio_message_params
      params.require(:twilio_message).permit(:body)
    end

end
