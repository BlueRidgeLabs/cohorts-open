# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('config/application', __dir__)

Cohorts::Application.load_tasks

if (Rails.env != 'production') && (Rails.env != 'staging')
  task default: %i[rubocop spec]
end
