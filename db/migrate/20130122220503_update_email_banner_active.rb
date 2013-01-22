class UpdateEmailBannerActive < ActiveRecord::Migration
  def up
    change_column :email_banners, :active, :boolean, default: false, null: false
  end

  def down
  end
end
