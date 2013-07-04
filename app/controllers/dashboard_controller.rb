

class DashboardController < ApplicationController
  layout false
  
  before_filter :signed_in_user, only: [:index, :show]
  
  def index
    
  end
  
  def show
    @page = params[:id]

    # get_order_statistics

    if params[:id] && (params[:id] == 'get_order_statistics')
    
      now = DateTime.now()
      
      where_clause = "1 = 1"
      
      if !current_user.admin? || params[:is_admin] == 'false'
        where_clause += " and webstores.user_id=#{current_user.id}"
      end
      
      if params['q']['webstore_id_eq'] && params['q']['webstore_id_eq'] != ''
        where_clause += " and orders.webstore_id=#{params['q']['webstore_id_eq']}"
      end
      
      select_clause = "strftime('%Y-%m-%d', orders.created_at) as ordered_date, strftime('%u', orders.created_at) as ordered_weekday"
      
      group_clause = "strftime('%Y-%m-%d', orders.created_at)"
      
      if params['scope'] == 'daily'
        where_clause += " and strftime('%Y-%m-%d', orders.created_at) >= '" + (now - 30).strftime('%Y-%m-%d') + "'"
        @date_range = (now-30).strftime('%d %b, %Y') + ' - ' + now.strftime('%d %b, %Y')
      end
      
      if params['scope'] == 'monthly'
        group_clause = "strftime('%Y-%m', orders.created_at)"
        where_clause += " and strftime('%Y-%m-%d', orders.created_at) >= '" + (now << 12).strftime('%Y-%m-%d') + "'"
        @date_range = (now << 12).strftime('%b, %Y') + ' - ' + now.strftime('%b, %Y')
      end
      
      if params['scope'] == 'weekly'
        group_clause = "strftime('%Y-%W', orders.created_at)"
        where_clause += " and strftime('%Y-%m-%d', orders.created_at) >= '" + (now - 7 * 26).strftime('%Y-%m-%d') + "'"
        @date_range = (now-7*26).strftime('%d %b, %Y') + ' - ' + now.strftime('%d %b, %Y')
      end
      
      select_clause += ", count(DISTINCT orders.id) as registered_orders"
      select_clause += ", count(DISTINCT order_items.id) as registered_order_items"
      select_clause += ", sum(orders.email_sent_count) as emails_sent"
      select_clause += ", sum(orders.email_read_count) as emails_clicks"
      select_clause += ", sum(order_items.share_count) as items_shared"
      select_clause += ", sum(order_items.click_count) as shared_items_click_count"
      select_clause += ", avg(order_items.click_count) as shared_items_clicks_average"
      
      @orders = Order.joins("LEFT JOIN webstores ON webstores.id = orders.webstore_id")
                      .joins("LEFT JOIN order_items ON orders.id = order_items.order_id")
                      .where(where_clause)
                      .select(select_clause).group(group_clause).order('orders.created_at desc')
      
      @orders.each do |order|
        if order.shared_items_clicks_average.nil?
          order.shared_items_clicks_average = 0
        end
        order.shared_items_clicks_average = sprintf('%.2f', order.shared_items_clicks_average)
        if params[:scope] == 'daily'
          order.ordered_date = DateTime.parse(order.ordered_date).strftime('%d %b, %Y')
        end
        
        if params[:scope] == 'monthly'
          order.ordered_date = DateTime.parse(order.ordered_date).strftime('%b, %Y')
        end
        
        if params[:scope] == 'weekly'
          order.ordered_date = (DateTime.parse(order.ordered_date).beginning_of_week).strftime('%d %b') + " - " + (DateTime.parse(order.ordered_date).beginning_of_week + 6).strftime('%d %b, %Y')
        end
      end
      
    end

    # get_webstores
    
    if params[:id] && params[:id] == 'get_webstores'
      if current_user.admin? && params[:is_admin] == 'true'
        @webstores = Webstore.all
      else
        @webstores = Webstore.where(:user_id => current_user.id)
      end
    end

  end
  
  
  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

end
