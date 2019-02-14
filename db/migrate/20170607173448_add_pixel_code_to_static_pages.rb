class AddPixelCodeToStaticPages < ActiveRecord::Migration
  def change
    add_column :static_pages, :pixel_code, :text
  end
end
