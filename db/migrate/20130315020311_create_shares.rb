class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :platform
      t.text :platform_user
      t.text :publish_result
      t.references :order_item

      t.timestamps
    end
    add_index :shares, :order_item_id
  end
end
