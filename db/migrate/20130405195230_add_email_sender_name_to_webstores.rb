class AddEmailSenderNameToWebstores < ActiveRecord::Migration
  def change
    add_column :webstores, :email_sender_name, :string
  end
end
