class Rename < ActiveRecord::Migration
  def change
    rename_column :contacts, :type, :contact_type
  end
end
