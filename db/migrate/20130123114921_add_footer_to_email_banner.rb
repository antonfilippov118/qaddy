class AddFooterToEmailBanner < ActiveRecord::Migration
  def change
    add_column :email_banners, :footer, :text, null: false, default: ""
  end
end
