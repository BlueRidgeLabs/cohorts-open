# frozen_string_literal: true
class ExtrapolatedAnswer < ActiveRecord::Base
  belongs_to :answer, required: true, dependent: :destroy
end
