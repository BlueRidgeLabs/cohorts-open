if Rails.env.staging? || Rails.env.production?
  Searchkick.aws_credentials = {
    access_key_id: ENV["AWS_ACCESS_KEY"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region: ENV["AWS_REGION"]
  }
end
