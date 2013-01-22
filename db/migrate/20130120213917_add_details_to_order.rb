class AddDetailsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :ref_code, :string
    add_column :orders, :email_sent_count, :integer, default: 0, null: false
    add_column :orders, :email_last_sent_at, :datetime
    add_column :orders, :email_read_count, :integer, default: 0, null: false
  end
end
