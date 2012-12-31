class Webstore < ActiveRecord::Base
  belongs_to :user
  has_many :orders
  
  attr_accessible :description, :name, :url, :user_id

  validates_presence_of :user
  validates :name, presence: true, length: { maximum: 50 }
  VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
  validates :url, presence: true, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }
  validates :description, presence: true, length: { maximum: 250 }
end
