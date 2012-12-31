class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.string :page_url, null: false
      t.string :image_url, null: false
      t.string :name, null: false
      t.string :description
      t.string :default_sharing_text
      t.decimal :total
      t.integer :qty
      t.references :order, null: false

      t.timestamps
    end
    add_index :order_items, :order_id
  end
end
