class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :type
      t.text :notes
      t.datetime :contact_time

      t.timestamps null: false
    end
  end
end
