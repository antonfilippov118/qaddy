class UpdateRefCodeForOldOrderItems < ActiveRecord::Migration
  def up
    OrderItem.all.each do |oi|
      oi.generate_ref_code
      oi.save!
    end
  end

  def down
  end
end
