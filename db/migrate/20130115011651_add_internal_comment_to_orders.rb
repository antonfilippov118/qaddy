class AddInternalCommentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :internal_comment, :text
  end
end
