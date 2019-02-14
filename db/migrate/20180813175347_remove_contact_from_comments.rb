class RemoveContactFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :contact_type, :string
    remove_column :comments, :contact_time, :datetime
  end
end
