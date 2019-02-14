# frozen_string_literal: true
class HandleIncomingSms
  class CancelForm
    def initialize(sms_form)
      @sms_form = sms_form
    end

    def call
      body = "Form data discarded. You may restart the form at any time by texting us \"#{@sms_form.twilio_keyword}\"."
      SMS.send @sms_form.phone_number, body
      @sms_form.delete
    end
  end
end
