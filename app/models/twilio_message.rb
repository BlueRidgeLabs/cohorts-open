# frozen_string_literal: true
class TwilioMessage < ActiveRecord::Base
  alias_attribute :time_sent, :date_sent
  belongs_to :person
  belongs_to :user
  belongs_to :sms_form
  belongs_to :previous_message, class_name: 'TwilioMessage'
  has_many :subsequent_messages, class_name: 'TwilioMessage', foreign_key: 'previous_message_id'

  phony_normalize :to, default_country_code: 'US'
  phony_normalized_method :to, default_country_code: 'US'

  phony_normalize :from, default_country_code: 'US'
  phony_normalized_method :from, default_country_code: 'US'

  default_scope { order(created_at: :desc) }
  scope :most_recent_from, (->(number) { where(from: number, created_at: 4.hours.ago..Time.zone.now) })
  scope :most_recent_to, (->(number) { where(to: number, created_at: 1.week.ago..Time.zone.now) })
end
