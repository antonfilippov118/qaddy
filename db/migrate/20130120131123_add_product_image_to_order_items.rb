class AddProductImageToOrderItems < ActiveRecord::Migration
  def self.up
    add_attachment :order_items, :product_image
  end

  def self.down
    remove_attachment :order_items, :product_image
  end
end
