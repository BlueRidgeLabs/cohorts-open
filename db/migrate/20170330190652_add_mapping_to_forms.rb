class AddMappingToForms < ActiveRecord::Migration
  def change
    add_column :forms, :mapping, :hstore
  end
end
