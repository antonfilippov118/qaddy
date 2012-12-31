module Api
  module V1
    module ApiHelper

      def sign_in(user)
        self.current_api_user = user
      end

      def signed_in?
        !current_api_user.nil?
      end

      def current_api_user=(user)
        @current_api_user = user
      end

      def current_api_user
        @current_api_user
      end

      def current_api_user?(user)
        user == current_api_user
      end

    end
  end
end
