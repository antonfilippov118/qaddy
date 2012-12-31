class OrderItem < ActiveRecord::Base
  belongs_to :order

  attr_accessible :default_sharing_text
  attr_accessible :description
  attr_accessible :image_url
  attr_accessible :name
  attr_accessible :page_url
  attr_accessible :qty
  attr_accessible :total

  VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

  validates :image_url, presence: true, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }
  validates :name, presence: true, length: { maximum: 200 }
  validates :page_url, presence: true, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }
  validates_presence_of :order

end
