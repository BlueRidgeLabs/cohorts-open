# frozen_string_literal: true
class EmailMessage < ActiveRecord::Base
  belongs_to :person
  belongs_to :user
  after_create :send_via_gmail, if: -> { delivery_method == 'gmail' }
  after_create :send_via_mandrill, if: -> { delivery_method == 'mandrill' }

  def as_mail
    Mail.new.tap do |mail|
      mail.from = from || person.email_address
      mail.to = to || user.email_address
      mail.subject = subject
      mail.body = body
      mail.content_type = 'text/html'
    end
  end

  def as_gmail_message
    GmailMessage.new(raw: as_mail.to_s, thread_id: thread_id)
  end

  def send_via_gmail
    user.authorize_gmail!
    result = GMAIL.send_user_message('me', as_gmail_message)
    msg = GMAIL.get_user_message('me', result.id)
    time_sent = Time.zone.parse(msg.payload.headers.find { |h| h.name == 'Date' }.value)
    update(gmail_id: msg.id, thread_id: msg.thread_id, time_sent: time_sent)
  end

  def send_via_mandrill
    MandrillMailer.outbound(to, subject, body).deliver_now
  end

  def self.find_replies(user, person_id)
    user.authorize_gmail!
    person = Person.find(person_id)
    return unless (first_message = where(user: user, person: person).order(:created_at).first)
    first_message_date = first_message.time_sent.strftime('%Y/%m/%d')
    if (messages = GMAIL.list_user_messages('me', q: "(from:#{person.email_address} OR to:#{person.email_address}) after:#{first_message_date}").messages)
      messages.each do |gmail_msg|
        message = find_or_initialize_by(gmail_id: gmail_msg.id, person: person, user: user)
        create_from_gmail(message) unless message.persisted?
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def self.create_from_gmail(message)
    gmail_msg = GMAIL.get_user_message('me', message.gmail_id)
    message.delivery_method = 'gmail_reply'
    message.thread_id = gmail_msg.thread_id
    message.from = gmail_msg.payload.headers.find { |h| h.name == 'From' }.value[/<(.*?)>/, 1]
    message.to = gmail_msg.payload.headers.find { |h| h.name == 'To' }.value[/<(.*?)>/, 1]
    message.subject = gmail_msg.payload.headers.find { |h| h.name == 'Subject' }.value
    message.body = gmail_msg.payload.parts.find { |p| p.mime_type == 'text/html' }.body.data
    message.time_sent = Time.zone.parse(gmail_msg.payload.headers.find { |h| h.name == 'Date' }.value)
    message.save
  end
end
