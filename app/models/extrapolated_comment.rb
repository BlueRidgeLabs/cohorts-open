# frozen_string_literal: true
class ExtrapolatedComment < ActiveRecord::Base
  belongs_to :comment, required: true, dependent: :destroy
end
