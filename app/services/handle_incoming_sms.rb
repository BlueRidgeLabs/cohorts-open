# frozen_string_literal: true
class HandleIncomingSms
  def initialize(message)
    @message = message
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def call
    if @message.body.casecmp('verify').zero?
      VerifyPerson.new(@message.from).call
    elsif @message.body.casecmp('cancel form').zero?
      CancelForm.new(@message.sms_form).call
    elsif @message.body.casecmp('submit form').zero?
      SubmitForm.new(@message.sms_form).call
    elsif @message.sms_form
      HandleForm.new(@message).call
    elsif (form = Form.find_by(twilio_keyword: @message.body.downcase))
      StartForm.new(@message, form).call
    elsif (user = @message.previous_message&.user)
      user.update(unread_messages: user.unread_messages + 1)
    else
      SMS.send @message.from, 'I did not understand that. Please re-type your keyword.'
    end
  end
end
