class CreateTraits < ActiveRecord::Migration
  def change
    create_table :traits do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    create_join_table :people, :traits, table_name: :person_traits do |t|
      t.string :value, null: false
      t.index :person_id
      t.index :trait_id
    end
  end
end
