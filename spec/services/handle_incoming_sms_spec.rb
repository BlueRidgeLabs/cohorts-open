# frozen_string_literal: true
require 'rails_helper'

describe 'Handling incoming text messages' do
  subject { HandleIncomingSms.new(message) }

  context 'when the message body is "verify"' do
    let!(:person) { create(:person) }
    let!(:message) { create(:twilio_message, body: 'verify', person: person, from: person.phone_number) }

    it 'should initiate the VerifyPerson service' do
      expect_any_instance_of(HandleIncomingSms::VerifyPerson).to receive(:call)
      subject.call
    end
  end

  context 'when the message body is "Verify"' do
    let!(:person) { create(:person) }
    let!(:message) { create(:twilio_message, body: 'Verify', person: person, from: person.phone_number) }

    it 'should initiate the VerifyPerson service' do
      expect_any_instance_of(HandleIncomingSms::VerifyPerson).to receive(:call)
      subject.call
    end
  end

  context 'when the message body is "VERIFY"' do
    let!(:person) { create(:person) }
    let!(:message) { create(:twilio_message, body: 'VERIFY', person: person, from: person.phone_number) }

    it 'should initiate the VerifyPerson service' do
      expect_any_instance_of(HandleIncomingSms::VerifyPerson).to receive(:call)
      subject.call
    end
  end

  context 'when the message is linked to an SmsForm' do
    let!(:sms_form) { create(:sms_form) }

    context 'and the message body is "cancel form"' do
      let!(:message) { create(:twilio_message, body: 'cancel form', sms_form: sms_form) }

      it 'should initiate the CancelForm service' do
        expect_any_instance_of(HandleIncomingSms::CancelForm).to receive(:call)
        subject.call
      end
    end

    context 'and the message body is "Cancel form"' do
      let!(:message) { create(:twilio_message, body: 'Cancel form', sms_form: sms_form) }

      it 'should initiate the CancelForm service' do
        expect_any_instance_of(HandleIncomingSms::CancelForm).to receive(:call)
        subject.call
      end
    end

    context 'and the message body is "CANCEL FORM"' do
      let!(:message) { create(:twilio_message, body: 'CANCEL FORM', sms_form: sms_form) }

      it 'should initiate the CancelForm service' do
        expect_any_instance_of(HandleIncomingSms::CancelForm).to receive(:call)
        subject.call
      end
    end

    context 'and the message body is "submit form"' do
      let!(:message) { create(:twilio_message, body: 'submit form', sms_form: sms_form) }

      it 'should initiate the SubmitForm service' do
        expect_any_instance_of(HandleIncomingSms::SubmitForm).to receive(:call)
        subject.call
      end
    end

    context 'and the message body is "Submit form"' do
      let!(:message) { create(:twilio_message, body: 'Submit form', sms_form: sms_form) }

      it 'should initiate the SubmitForm service' do
        expect_any_instance_of(HandleIncomingSms::SubmitForm).to receive(:call)
        subject.call
      end
    end

    context 'and the message body is "SUBMIT FORM"' do
      let!(:message) { create(:twilio_message, body: 'SUBMIT FORM', sms_form: sms_form) }

      it 'should initiate the SubmitForm service' do
        expect_any_instance_of(HandleIncomingSms::SubmitForm).to receive(:call)
        subject.call
      end
    end

    context 'and the message body is anything else' do
      let!(:message) { create(:twilio_message, sms_form: sms_form) }

      it 'should initiate the HandleForm service' do
        expect_any_instance_of(HandleIncomingSms::HandleForm).to receive(:call)
        subject.call
      end
    end
  end

  context 'when the message is not linked to an SmsForm' do
    context 'and the message body matches a form twilio keyword' do
      let!(:form) { create(:form) }
      let!(:message) { create(:twilio_message, body: form.twilio_keyword) }

      it 'should initiate the StartForm service' do
        expect_any_instance_of(HandleIncomingSms::StartForm).to receive(:call)
        subject.call
      end
    end

    context 'and the message body does not match a form twilio keyword' do
      let!(:message) { create(:twilio_message) }

      it 'should send an SMS stating that the keyword is unrecognized' do
        expect(SMS).to receive(:send).with(message.from, 'I did not understand that. Please re-type your keyword.')
        subject.call
      end
    end
  end
end
