class AddFormAndBodyToLandingPages < ActiveRecord::Migration
  def change
    add_column :landing_pages, :body, :text
    add_reference :landing_pages, :form, index: true, foreign_key: true
  end
end
