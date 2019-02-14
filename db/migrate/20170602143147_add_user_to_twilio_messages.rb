class AddUserToTwilioMessages < ActiveRecord::Migration
  def change
    add_reference :twilio_messages, :user, index: true, foreign_key: true
  end
end
