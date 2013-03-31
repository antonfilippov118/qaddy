class AddDiscountCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :discount_code, :string
  end
end
