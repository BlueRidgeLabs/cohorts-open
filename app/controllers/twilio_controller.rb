# frozen_string_literal: true
class TwilioController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :create_message, :find_person, :find_previous_message

  def receive
    HandleIncomingSms.new(@message).call
    head :ok
  end

  private

    def create_message
      @message = TwilioMessage.create(
        message_sid: params[:MessageSid],
        date_sent: params[:DateSent] || Time.zone.now,
        account_sid: params[:AccountSid],
        from: PhonyRails.normalize_number(params[:From]),
        to: PhonyRails.normalize_number(params[:To]),
        body: params[:Body],
        status: params[:SmsStatus],
        error_code: params[:ErrorCode],
        error_message: params[:ErrorMessage]
      )
    end

    def find_person
      if (person = Person.find_by(phone_number: @message.from))
        @message.update(person: person)
      end
    end

    def find_previous_message
      @form_message = TwilioMessage.most_recent_from(PhonyRails.normalize_number(params[:From])).second
      @user_message = TwilioMessage.most_recent_to(PhonyRails.normalize_number(params[:From])).first
      if @form_message&.sms_form && !['submit form', 'cancel form'].include?(@form_message&.body&.downcase)
        @message.update(
          previous_message: @form_message,
          sms_form: @form_message.sms_form
        )
      elsif @user_message&.user
        @message.update(
          previous_message: @user_message,
          user: @user_message.user
        )
      end
    end
end
