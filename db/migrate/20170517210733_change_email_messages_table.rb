class ChangeEmailMessagesTable < ActiveRecord::Migration
  def change
    rename_table :mandrill_messages, :email_messages
    add_column :email_messages, :delivery_method, :string
    add_column :email_messages, :thread_id, :string
  end
end
