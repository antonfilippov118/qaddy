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

  def webstore_send_from_email(webstore)
    # subdomain
    sub = webstore.name.gsub(/[^0-9a-z]/i, '').downcase[0, 20]

    # name
    name_tmp = ""
    if webstore.email_sender_name.present?
      name_tmp = webstore.email_sender_name
    else
      name_tmp = webstore.name
    end
    name = name_tmp.lines.first.strip[0,50]

    # Format email address with name
    email = Rails.application.config.qaddy[:webstore_email_from_format] % { name: name, sub: sub }
  end

end
