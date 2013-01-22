class AddDetailsToOrderItem < ActiveRecord::Migration
  def change
    add_column :order_items, :ref_code, :string
    add_column :order_items, :share_count, :integer, default: 0, null: false
    add_column :order_items, :click_count, :integer, default: 0, null: false
  end
end
