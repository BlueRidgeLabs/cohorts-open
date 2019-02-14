class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :name
      t.string :items, array: true, default: []
      t.integer :engagement_ids, array: true, default: []

      t.timestamps null: false
    end
  end
end
