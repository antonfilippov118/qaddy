class AddAttachmentBannerToEmailBanners < ActiveRecord::Migration
  def self.up
    add_attachment :email_banners, :banner
  end

  def self.down
    remove_attachment :email_banners, :banner
  end
end
