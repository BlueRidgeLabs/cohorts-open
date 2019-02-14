class CreateMandrillMessages < ActiveRecord::Migration
  def change
    create_table :mandrill_messages do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.string :body
      t.belongs_to :person
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
