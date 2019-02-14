# frozen_string_literal: true
class HandleIncomingSms
  class StartForm
    def initialize(message, form)
      @message = message
      @sms_form = SmsForm.create(
        form: form,
        phone_number: @message.from,
        values: {},
        field_counter: 0
      )
      @message.update(sms_form: @sms_form)
    end

    def call
      SMS.send @message.from, "#{@sms_form.name} - #{@sms_form.description}"
      SMS.send @message.from, 'You may cancel the form at any time by replying "cancel form".'
      ReplyWithCurrentField.new(@sms_form).call
    end
  end
end
