# frozen_string_literal: true
class SmsForm < ActiveRecord::Base
  belongs_to :form
  has_many :twilio_messages
  delegate :name, :description, :twilio_keyword, :fields, :flattened_fields, to: :form

  def submit_on_wufoo
    form.wufoo_form.submit(values)
  end
end
