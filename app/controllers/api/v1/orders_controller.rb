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

          # # setup send_email_after_hours from webstore settings
          # @order.send_email_after_hours = @webstore.default_send_after_hours if @order.send_email_after_hours.nil?

          # # find most recent active campaign and save discount info with an order
          # @campaign = @order.webstore.campaigns.where(active: true).order('created_at desc').first
          # if @campaign
          #   @order.discount_code = @campaign.code
          #   @order.discount_code_perc = @campaign.amount
          #   @order.tracking_url_params = @campaign.tracking_url_params
          # end

          # # apply default sharing texts
          # @order.order_items.each do |oi|
          #   # use already provided sharing text
          #   next if oi.default_sharing_text.present?
          #   # use webstore's sharing text if any...
          #   default_sharing_text = @webstore.default_sharing_texts.where(active: true).order('use_counter asc').first
          #   # or use the global ones if none present
          #   if default_sharing_text.nil?
          #     default_sharing_text = DefaultSharingText.global_only.where(active:true).order('use_counter asc').first
          #   end
          #   # write it down, if we have any
          #   if default_sharing_text.present?
          #     default_sharing_text.increment!(:use_counter)
          #     oi.default_sharing_text = default_sharing_text.text
          #   end
          # end

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
