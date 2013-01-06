module Api
  module V1
    class OrdersController < ApiController
      before_filter :correct_webstore

      def index
        respond_with @webstore.orders
      end

      def create
        begin
          @order = @webstore.orders.build(params[:order])
          @order.save!
        rescue Exception => e
          respond_with( { error: e.message }, status: :unprocessable_entity, location: nil )
          return
        end

        respond_with(@order, location: nil)
      end

      private

        def correct_webstore
          begin
            @webstore = current_api_user.webstores.find(params[:webstore_id])
          rescue ActiveRecord::RecordNotFound => e
            body = { error: e.message }
            respond_with(body, status: :not_found, location: nil)
          rescue Exception => e
            body = { error: e.message }
            respond_with(body, status: :unprocessable_entity, location: nil)
          end
        end

    end
  end
end
