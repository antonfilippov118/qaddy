class AddShortUrlsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :short_url_emailview, :string
    add_column :orders, :short_url_doshare, :string
  end
end
