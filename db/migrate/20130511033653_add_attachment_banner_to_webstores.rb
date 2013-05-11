class AddAttachmentBannerToWebstores < ActiveRecord::Migration
  def self.up
    change_table :webstores do |t|
      t.attachment :banner
    end
  end

  def self.down
    drop_attached_file :webstores, :banner
  end
end
