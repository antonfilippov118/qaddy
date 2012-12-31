module Api
  module V1
    class ApiController < ActionController::Base
      include ApiHelper

      before_filter :api_authenticate
      respond_to :json

      private

        def api_authenticate

          if request.authorization.nil?
            body = { error: "Unauthorized" }
            respond_with(body, status: :unauthorized, location: nil)
            return
          end

          username, password = ActionController::HttpAuthentication::Basic::user_name_and_password(request)
          api_key = ApiKey.find_by_key(password)

          if api_key && api_key.enabled && api_key.user.id.to_s == username
            sign_in(api_key.user)
          elsif api_key && !api_key.enabled
            body = { error: "API not enabled for this user" }
            respond_with(body, status: :forbidden, location: nil)
          else
            body = { error: "Unauthorized" }
            respond_with(body, status: :unauthorized, location: nil)
          end
        end

    end
  end
end
