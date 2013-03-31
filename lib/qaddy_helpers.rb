module QaddyHelpers
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers

  def get_bitly_client
    Bitly.use_api_version_3
    Bitly.new(Rails.application.config.bitly[:username], Rails.application.config.bitly[:api_key])
  end

  def default_url_options
    Rails.application.config.action_mailer[:default_url_options]
  end

  def set_default_url_options
    Rails.application.default_url_options = self.default_url_options
  end

end
