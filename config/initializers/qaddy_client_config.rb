require 'qaddy_client'

QaddyClient.configure do |config|

  # development environment
  if Rails.env.development?
    config.api_host = 'localhost:3000'
    config.api_scheme = 'http'
    config.user_id = 1
    config.user_api_key = 'dev-apikey'
    config.webstore_id = 1
  end

  # test environment
  if Rails.env.test?
    config.api_host = 'localhost:3000'
    config.api_scheme = 'http'
    config.user_id = 1
    config.user_api_key = 'test-apikey'
    config.webstore_id = 1
  end

  # production environment
  if Rails.env.production?
    config.api_host     = ENV["QADDY_CLIENT_API_HOST"]
    config.api_scheme   = ENV["QADDY_CLIENT_API_SCHEME"]
    config.user_id      = ENV["QADDY_CLIENT_USER_ID"]
    config.user_api_key = ENV["QADDY_CLIENT_USER_API_KEY"]
    config.webstore_id  = ENV["QADDY_CLIENT_WEBSTORE_ID"]
  end

end
