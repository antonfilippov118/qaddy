class AddDefaultSendAfterHoursToWebstores < ActiveRecord::Migration
  def change
    add_column :webstores, :default_send_after_hours, :integer, default: 120
  end
end
