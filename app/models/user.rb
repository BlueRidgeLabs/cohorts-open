# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :two_factor_authenticatable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2], stretches: 10

  has_paper_trail
  has_secure_token # for calendar feeds
  has_one_time_password encrypted: true

  # for sanity's sake
  alias_attribute :email_address, :email

  validates :phone_number, presence: true

  has_many :email_messages

  def active_for_authentication?
    if super && approved?
      true
    else
      Rails.logger.warn("[SEC] User #{email} is not approved but attempted to authenticate.")
      false
    end
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def approve!
    update_attributes(approved: true)
    Rails.logger.info("Approved user #{email}")
  end

  def unapprove!
    update_attributes(approved: false)
    Rails.logger.info("Unapproved user #{email}")
  end

  def full_name # convienence for calendar view.
    name
  end

  def gravatar_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=100&d=mm"
  end

  def send_two_factor_authentication_code(otp_code)
    SMS.send phone_number, "#{otp_code} is your Cohorts authentication code."
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def need_two_factor_authentication?(request)
    Rails.env.staging? || Rails.env.production?
  end
  # rubocop:enable Lint/UnusedMethodArgument

  def authorize_gmail!
    GMAIL.authorization = Google::APIClient::ClientSecrets.new(
      'web' => {
        'access_token'  => oauth_token,
        'refresh_token' => oauth_refresh_token,
        'client_id'     => ENV['GOOGLE_CLIENT_ID'],
        'client_secret' => ENV['GOOGLE_CLIENT_SECRET']
      }
    ).to_authorization
    GMAIL.authorization.refresh!
  end

  def self.from_omniauth(auth)
    user = find_by(email_address: auth.info.email)
    if user.oauth_provider.blank?
      user.update(
        oauth_provider: auth.provider,
        oauth_uid: auth.uid,
        oauth_token: auth.credentials.token,
        oauth_refresh_token: auth.credentials.refresh_token,
        name: auth.info.name
      )
    end
    user.update(image_url: auth.info.image) if user.image_url.blank?
    user
  end
end
