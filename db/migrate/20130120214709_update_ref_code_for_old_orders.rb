class UpdateRefCodeForOldOrders < ActiveRecord::Migration
  def up
    Order.all.each do |o|
      o.generate_ref_code
      o.save!
    end
  end

  def down
  end
end
