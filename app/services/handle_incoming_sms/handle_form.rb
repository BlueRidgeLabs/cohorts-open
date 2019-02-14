# frozen_string_literal: true
class HandleIncomingSms
  class HandleForm
    def initialize(message)
      @message = message
      @sms_form = @message.sms_form
    end

    def call
      HandleFieldResponse.new(@message).call
      if @sms_form.field_counter == @sms_form.flattened_fields.count
        body = 'Form complete. Reply with "submit form" to submit your responses or "cancel form" to discard them.'
        SMS.send @sms_form.phone_number, body
      else
        ReplyWithCurrentField.new(@sms_form).call
      end
      @sms_form.save
    end
  end
end
