class CreateImportJobItems < ActiveRecord::Migration
  def change
    create_table :import_job_items do |t|
      t.datetime :last_process_date
      t.text :last_process_message
      t.string :last_process_status
      t.string :order_number
      t.decimal :order_total
      t.string :order_customer_email
      t.string :order_customer_name
      t.datetime :order_send_email_at
      t.string :order_item_page_url
      t.string :order_item_image_url
      t.string :order_item_name
      t.string :order_item_description
      t.decimal :order_item_total
      t.integer :order_item_qty
      t.references :import_job

      t.timestamps
    end
    add_index :import_job_items, :import_job_id
  end
end
