# frozen_string_literal: true
class HandleIncomingSms
  class HandleFieldResponse
    def initialize(message)
      @message = message
      @sms_form = @message.sms_form
      @field = @sms_form.flattened_fields[@sms_form.field_counter]
    end

    def call
      if %w(radio select checkbox).include? @field['Type']
        handle_fixed_fields
      else
        @sms_form.values[@field['ID']] = @message.body
        @sms_form.increment!(:field_counter)
      end
    end

    private

      def handle_fixed_fields
        if @message.body.split(',').any? { |n| number_or_nil(n).nil? }
          SMS.send @message.from, 'Please answer using only numbers.'
        elsif @field['Type'] == 'checkbox'
          handle_checkbox
        else
          handle_radio
        end
      end

      def handle_checkbox
        subfields = @sms_form.fields.find { |f| f['ID'] == @field['ID'] }['SubFields']
        choices = @message.body.split(',').map { |c| number_or_nil(c) }
        subfields.each_with_index do |subfield, i|
          @sms_form.values[subfield['ID']] = '1' if choices.include?(i+1)
        end
        @sms_form.increment!(:field_counter)
      end

      def handle_radio
        choices = @sms_form.fields.find { |f| f['ID'] == @field['ID'] }['Choices']
        choices = choices.reject { |c| c['Label'].blank? }
        @sms_form.values[@field['ID']] = choices[number_or_nil(@message.body) - 1]
        @sms_form.increment!(:field_counter)
      end

      def number_or_nil(string)
        Integer(string || '')
      rescue ArgumentError
        nil
      end
  end
end
