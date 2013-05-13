class ImportJobItem < ActiveRecord::Base
  belongs_to :import_job

  attr_accessible :last_process_date, :last_process_message, :last_process_status, :order_customer_email, :order_customer_name, :order_item_description, :order_item_image_url, :order_item_name, :order_item_page_url, :order_item_qty, :order_item_total, :order_number, :order_send_email_at, :order_total

  def display_name
    "Import Job Item ##{self.id}"
  end
  
end
