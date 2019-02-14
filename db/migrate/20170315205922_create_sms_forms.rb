class CreateSmsForms < ActiveRecord::Migration
  def change
    remove_column :twilio_messages, :form_values, :hstore
    remove_column :twilio_messages, :field_counter, :integer
    remove_reference :twilio_messages, :form, index: true, foreign_key: true
    add_reference :twilio_messages, :person, index: true, foreign_key: true

    create_table :sms_forms do |t|
      t.belongs_to :form, index: true, foreign_key: true
      t.string :phone_number
      t.hstore :values
      t.integer :field_counter

      t.timestamps null: false
    end

    add_reference :twilio_messages, :sms_form, index: true, foreign_key: true
  end
end
