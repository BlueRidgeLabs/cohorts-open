# frozen_string_literal: true
class HandleIncomingSms
  class SubmitForm
    def initialize(sms_form)
      @sms_form = sms_form
    end

    def call
      result = @sms_form.submit_on_wufoo
      if result['Success'].zero?
        SMS.send @sms_form.phone_number, result['ErrorText']
      else
        SMS.send @sms_form.phone_number, 'Form submitted successfully. Thank you for using Cohorts!'
      end
    end
  end
end
