class AddTimeSentAndGmailIdToEmailMessages < ActiveRecord::Migration
  def change
    add_column :email_messages, :time_sent, :datetime
    add_column :email_messages, :gmail_id, :string
  end
end
