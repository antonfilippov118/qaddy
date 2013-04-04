Qaddy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # default app host for mailer
  config.action_mailer.default_url_options = { host: ENV['DEFAULT_URL_OPTIONS'] }


  # perform email deliveries to the file (Rails.root/tmp/mail/ dir)
  # clear this folder before testing
  # all emails to the same destination will be written in the same email
  # add .eml extension to the file to be able to actually view the email (at least the first one if there are more than one written)
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :file
  config.action_mailer.file_settings = { location: Rails.root.join('tmp/mail') }

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Prepend all log lines with the following tags
  config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new('log/development.log'))

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
end
