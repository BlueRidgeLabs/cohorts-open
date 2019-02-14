class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_provider, :string
    add_column :users, :oauth_uid, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_refresh_token, :string
    add_column :users, :image_url, :string
  end
end
