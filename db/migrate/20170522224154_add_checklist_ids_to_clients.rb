class AddChecklistIdsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :checklist_ids, :integer, array: true, default: []
    add_column :engagements, :checklist_ids, :integer, array: true, default: []
    remove_column :checklists, :engagement_ids, :integer, array: true, default: []
  end
end
