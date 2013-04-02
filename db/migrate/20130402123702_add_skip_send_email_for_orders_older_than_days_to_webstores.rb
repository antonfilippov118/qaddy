class AddSkipSendEmailForOrdersOlderThanDaysToWebstores < ActiveRecord::Migration
  def change
    add_column :webstores, :skip_send_email_for_orders_older_than_days, :integer, null: false, default: 60
  end
end
