class CreateSessionChecklists < ActiveRecord::Migration
  def change
    create_table :session_checklists do |t|
      t.belongs_to :research_session, index: true, foreign_key: true
      t.belongs_to :checklist, index: true, foreign_key: true
      t.hstore :state

      t.timestamps null: false
    end
  end
end
