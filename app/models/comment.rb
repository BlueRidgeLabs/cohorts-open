# frozen_string_literal: true
class Comment < ActiveRecord::Base
  has_paper_trail
  validates_presence_of :content
  attr_accessor :contact_check, :contact_type
  belongs_to :commentable, polymorphic: true, touch: true
end
