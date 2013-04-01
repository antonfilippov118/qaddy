class AddSendEmailWithoutDiscountToWebstores < ActiveRecord::Migration
  def change
    add_column :webstores, :send_email_without_discount, :boolean, default: false
  end
end
