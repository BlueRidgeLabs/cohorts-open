if Rails.env.production?
  OmniAuth.config.full_host = 'https://cohortsfeedback.com'
elsif Rails.env.staging?
  OmniAuth.config.full_host = 'https://staging.cohortsfeedback.com'
else
  OmniAuth.config.full_host = 'http://localhost:3000'
end
