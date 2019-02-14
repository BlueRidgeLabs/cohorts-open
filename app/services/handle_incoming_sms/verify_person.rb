# frozen_string_literal: true
class HandleIncomingSms
  class VerifyPerson
    def initialize(phone_number)
      @person = Person.find_by(phone_number: phone_number)
    end

    def call
      @person.update(verified: 'Verified by Text Message')
      message = 'Thank you for verifying your account. We will mail you your $5 VISA gift card right away.'
      SMS.send @person.phone_number, message
    end
  end
end
