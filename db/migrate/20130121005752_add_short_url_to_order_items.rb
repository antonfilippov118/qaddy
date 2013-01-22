class AddShortUrlToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :short_url_clicked, :string
  end
end
