class AddWebstoreNumberIndexToOrders < ActiveRecord::Migration
  def change
    add_index :orders, [:number, :webstore_id], unique: true
  end
end
