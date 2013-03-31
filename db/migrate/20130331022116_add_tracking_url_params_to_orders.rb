class AddTrackingUrlParamsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tracking_url_params, :string
  end
end
