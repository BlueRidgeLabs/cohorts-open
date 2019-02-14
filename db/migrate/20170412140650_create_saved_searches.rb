class CreateSavedSearches < ActiveRecord::Migration
  def change
    create_table :saved_searches do |t|
      t.string :label
      t.string :query

      t.timestamps null: false
    end

    add_column :clients, :saved_search_ids, :integer, array: true, default: []
    remove_column :engagements, :search_query, :text 
    add_column :engagements, :saved_search_ids, :integer, array: true, default: []
  end
end
