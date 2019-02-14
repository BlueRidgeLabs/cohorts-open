# frozen_string_literal: true
class HandleIncomingSms
  class ReplyWithCurrentField
    include GsmHelper

    def initialize(sms_form)
      @sms_form = sms_form
      @to = @sms_form.phone_number
      @field = @sms_form.flattened_fields[@sms_form.field_counter]
    end

    def call
      SMS.send @to, to_gsm0338(@field['Title'])
      case @field['Type']
      when 'checkbox'
        send_checkbox_options
      when 'radio', 'select'
        send_radio_options
      end
    end

    private

      def send_checkbox_options
        @initial_message = 'You may choose one or more of the following (respond with the numbers preceding the choices, separated by commas):'
        @choices_key = 'SubFields'
        send_options
      end

      def send_radio_options
        @initial_message = 'You may choose one of the following (respond with the number preceding the choice):'
        @choices_key = 'Choices'
        send_options
      end

      def send_options
        SMS.send @to, @initial_message
        choices = @sms_form.fields.find { |f| f['ID'] == @field['ID'] }[@choices_key]
        counter = 1
        choices.each do |choice|
          next if choice['Label'].blank?
          SMS.send @to, "#{counter}. #{choice['Label']}"
          counter += 1
        end
      end
  end
end
