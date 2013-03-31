require 'koala'

class ShareController < ApplicationController
  layout 'share'
  respond_to :html, :json

  # GET '/share/emailview/:ref_code', as: :share_emailview
  def emailview
    # TODO: emailview
  end

  # GET '/share/doshare/:ref_code', as: :share_doshare
  # GET '/share/doshare', as: :share_doshare_redirect
  def doshare
    @fb_app_id = Koala::Facebook::OAuth.new.app_id
    @redirect = share_doshare_redirect_url

    @ref_code = nil
    @order = nil

    if params[:ref_code]
      @ref_code = params[:ref_code]
    elsif session[:ref_code]
      @ref_code = session[:ref_code]
    end

    if @ref_code
      logger.info "/share/doshare : #{@ref_code}"
      session[:ref_code] = @ref_code
      @order = Order.find_by_ref_code(@ref_code)
    end
  end

  # GET '/share/getcode', as: :share_getcode
  def getcode
    # Get ref_code from session. Check if any order_item was shared. Check if we have discount code
    ref_code = session[:ref_code]
    order = Order.find_by_ref_code(ref_code)
    order.order_items.each do |oi|
      if oi.share_count > 0
        render text: order.discount_code
        return
      end
    end
    # order not found or no items shared
    head :bad_request
  end

  # GET '/share/clicked/:ref_code', as: :share_clicked
  def clicked
    order_item = OrderItem.find_by_ref_code(params[:ref_code])

    if order_item
      # increment click count
      order_item.click_count += 1
      order_item.save!
      # compose URL
      uri = URI.parse(order_item.page_url)
      uri.query = [uri.query, order_item.order.tracking_url_params].compact.join('&')
      redirect_to uri.to_s
    else
      render text: 'Item does not exist'
    end
  end

  # POST '/share/publish', as: :share_publish
  # params: comment, item_ref_code
  def publish
    @success = false
    @ref_code = session[:ref_code]
    @order = Order.find_by_ref_code(@ref_code)
    @oi = @order.order_items.find_by_ref_code(params[:item_ref_code])

    if @oi
      begin
        @oauth = Koala::Facebook::OAuth.new
        @access_token = @oauth.get_user_info_from_cookies(cookies)
        @extended_access_token = @oauth.exchange_access_token_info(@access_token['access_token'])
        session[:extended_access_token] = @extended_access_token if @extended_access_token.present?
      rescue Exception => ex
        logger.info("Reusing access token")
      end

      @extended_access_token = session[:extended_access_token] if @extended_access_token.nil?

      @graph = Koala::Facebook::API.new(@extended_access_token['access_token'])

      # get FB user data (id, name, gender, locale, verified, ...)
      @fbuser = @graph.get_object('me')

      # post FB wall comment
      @res = @graph.put_wall_post(params[:comment], {
        name: @oi.name,
        link: @oi.short_url_clicked,
        description: @oi.description,
        #picture: share_order_item_image_url(@oi.ref_code) # use our stored version of the item image (can't be used with local testing)
        picture: @oi.image_url # use original item image directly from retailer's site (for local testing only)
      })

      # save results
      @share = Share.new(
        platform: 'FB',
        platform_user: @fbuser.to_json,
        publish_result: @res.to_json
      )
      @share.order_item = @oi
      @share.save!

      @oi.share_count += 1
      @oi.save!

      # send discount code by email
      ShareMailer.discount_code(@order).deliver unless @order.discount_code.blank?

      @success = true
    end

    body = { text: @success ? "Compartido!" : "Error..." }
    # respond_with(body, status: :created)

    respond_to do |format|
      format.html { render 'doshare' }
      format.json { render json: body, status: :created }
    end
  end

  # GET '/share/order_item_image/:ref_code', as: :share_order_item_image
  def order_item_image
    oi = OrderItem.find_by_ref_code(params[:ref_code])
    att = Paperclip.io_adapters.for(oi.product_image.styles[:small])

    expires_in 1.day, :public => true
    send_data open(att.path) {|f| f.read }, filename: oi.product_image_file_name, type: oi.product_image_content_type, disposition: 'inline'
  end

end
