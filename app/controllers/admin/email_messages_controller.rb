# frozen_string_literal: true
class Admin::EmailMessagesController < ApplicationController
  before_action :find_sender

  def create
    valid_to_params.each do |to|
      EmailMessage.create(
        user: current_admin_user,
        person: Person.find_by(email_address: to),
        delivery_method: @delivery_method,
        from: @from,
        to: to,
        subject: email_message_params[:subject],
        body: email_message_params[:body]
      )
    end
    respond_to do |format|
      format.html do
        flash[:notice] = 'Email messages sent!'
        redirect_to :back
      end
      format.js {}
    end
  end

  private

    def find_sender
      @delivery_method = current_admin_user.oauth_provider ? :gmail : :mandrill_messages
      @from = current_admin_user.oauth_provider ? current_admin_user.email_address : ENV['MAILER_SENDER']
    end

    def valid_to_params
      params[:to].
        compact.
        reject(&:blank?).
        select do |e|
          e[/^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]
{2,6})$/i]
        end
    end

    def email_message_params
      params.require(:email_message).permit(:subject, :body)
    end
end
