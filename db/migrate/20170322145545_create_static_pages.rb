class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :title
      t.text :body
      t.string :slug, unique: true

      t.timestamps null: false
    end
  end
end
