class AddFormatToLandingPages < ActiveRecord::Migration
  def change
    add_column :landing_pages, :format, :string
  end
end
