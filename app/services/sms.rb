# frozen_string_literal: true
class SMS
  class << self
    def send(to, body)
      client.messages.create(
        from: from,
        to:   to,
        body: body
      )
    end

    private

      def client
        Twilio::REST::Client.new
      end

      def from
        ENV['TWILIO_NUMBER']
      end
  end
end
