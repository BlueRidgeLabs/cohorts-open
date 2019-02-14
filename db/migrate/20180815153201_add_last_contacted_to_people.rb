class AddLastContactedToPeople < ActiveRecord::Migration
  def change
    add_column :people, :last_contacted, :datetime
  end
end
