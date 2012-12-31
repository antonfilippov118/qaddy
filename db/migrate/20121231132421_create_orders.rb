class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number, null: false
      t.decimal :total, null: false
      t.string :customer_email, null: false
      t.string :customer_name, null: false
      t.integer :send_email_after_hours
      t.datetime :send_email_at
      t.integer :discount_code_perc, default: 0
      t.references :webstore, null: false

      t.timestamps
    end
    add_index :orders, :webstore_id
    add_index :orders, :number
  end
end
