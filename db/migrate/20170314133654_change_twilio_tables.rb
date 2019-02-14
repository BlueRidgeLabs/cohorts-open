class ChangeTwilioTables < ActiveRecord::Migration
  def change
    remove_column :twilio_messages, :date_created, :datetime
    remove_column :twilio_messages, :date_updated, :datetime
    remove_column :twilio_messages, :direction, :string
    remove_column :twilio_messages, :from_city, :string
    remove_column :twilio_messages, :from_state, :string
    remove_column :twilio_messages, :from_zip, :string
    remove_column :twilio_messages, :wufoo_formid, :string
    remove_column :twilio_messages, :conversation_count, :integer
    remove_column :twilio_messages, :signup_verify, :string

    enable_extension "hstore"
    add_column :twilio_messages, :form_values, :hstore

    change_table :twilio_messages do |t|
      t.belongs_to :form, index: true, foreign_key: true
      t.references :previous_message, index: true
      t.integer :field_counter
    end

    drop_table :twilio_wufoos, force: :cascade do |t|
      t.string   "name",           limit: 510
      t.string   "wufoo_formid",   limit: 510
      t.string   "twilio_keyword", limit: 510
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "status",                     null: false
      t.string   "end_message",    limit: 510
      t.string   "form_type",      limit: 510
    end

    add_column :forms, :twilio_keyword, :string
  end
end
