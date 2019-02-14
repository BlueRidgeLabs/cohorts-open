class AddLinkDescriptionToStaticPages < ActiveRecord::Migration
  def change
    add_column :static_pages, :link_description, :string
  end
end
