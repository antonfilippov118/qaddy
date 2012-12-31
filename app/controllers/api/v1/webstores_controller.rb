module Api
  module V1
    class WebstoresController < ApiController

      def index
        respond_with current_api_user.webstores
      end

    end
  end
end
