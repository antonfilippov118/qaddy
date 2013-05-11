class DropEmailBannersTable < ActiveRecord::Migration
  def up
    drop_table :email_banners
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
