class AddFooterToWebstores < ActiveRecord::Migration
  def change
    add_column :webstores, :footer, :text
  end
end
