class Share < ActiveRecord::Base
  belongs_to :order_item
  attr_accessible :platform, :platform_user, :publish_result
end
