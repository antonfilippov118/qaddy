module Api
  module V1
    class OrdersController < ApiController
      before_filter :correct_webstore

      def index
        respond_with @webstore.orders
      end

      def create
        begin
          # bild order
          @order = @webstore.orders.build(params[:order])

          # setup send_email_after_hours from webstore settings
          @order.send_email_after_hours = @webstore.default_send_after_hours if @order.send_email_after_hours.nil?

          # find most recent active campaign and save discount info with an order
          @campaign = @order.webstore.campaigns.where(active: true).order('created_at desc').first
          if @campaign
            @order.discount_code = @campaign.code
            @order.discount_code_perc = @campaign.amount
            @order.tracking_url_params = @campaign.tracking_url_params
          end

          # save
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
