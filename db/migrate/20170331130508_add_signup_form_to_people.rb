class AddSignupFormToPeople < ActiveRecord::Migration
  def change
    add_column :people, :signup_form_id, :integer
  end
end
