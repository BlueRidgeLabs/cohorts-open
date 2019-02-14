class TwoFactorAuthenticationAddToUsers < ActiveRecord::Migration
  def change
    add_column :users, :second_factor_attempts_count, :integer, default: 0
    add_column :users, :encrypted_otp_secret_key, :string
    add_column :users, :encrypted_otp_secret_key_iv, :string
    add_column :users, :encrypted_otp_secret_key_salt, :string

    add_index :users, :encrypted_otp_secret_key, unique: true

    unless reverting?
      User.reset_column_information

      User.find_each do |user|
        user.otp_secret_key = ROTP::Base32.random_base32
        user.save!
      end
    end
  end
end
