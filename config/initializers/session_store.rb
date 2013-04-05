# Be sure to restart your server when you modify this file.

# Qaddy::Application.config.session_store :cookie_store, key: '_qaddy_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
Qaddy::Application.config.session_store :active_record_store,
  key: 'lacp_sess',
  secure: Rails.env == 'production',
  httponly: true

ActiveRecord::SessionStore.session_class = Session
