class AddCreatedByToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :created_by, :integer
  end
end
