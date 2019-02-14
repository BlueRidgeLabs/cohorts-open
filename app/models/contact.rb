# frozen_string_literal: true
class Contact < ActiveRecord::Base
  validates_presence_of :contact_type
  belongs_to :contactable, polymorphic: true, touch: true
end
