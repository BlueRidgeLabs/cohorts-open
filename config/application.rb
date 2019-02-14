require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))




module Cohorts

  class Application < Rails::Application

    # this enables us to know who created a user or updated a user
    require "#{config.root}/lib/extensions/with_user"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += %W(#{config.root}/app/jobs #{config.root}/app/mailers #{config.root}/app/sms #{config.root}/lib)

    # Analytics
    Cohorts::Application.config.google_analytics_enabled = false

    # compile the placeholder
    config.assets.precompile += %w( holder.js )

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = ENV['TIME_ZONE'] || "Eastern Time (US & Canada)"

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.test_framework :rspec
      g.jbuilder false
      g.assets false
      g.helper false
    end

    config.middleware.use "Middleware::HealthCheck"

  end

end
