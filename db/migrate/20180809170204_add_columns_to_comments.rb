class AddColumnsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :contact_type, :string
    add_column :comments, :contact_time, :datetime
  end
end
