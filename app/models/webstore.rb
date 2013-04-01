class Webstore < ActiveRecord::Base
  belongs_to :user
  has_many :orders, dependent: :destroy
  has_many :email_banners, dependent: :destroy
  has_many :campaigns, dependent: :destroy

  attr_accessible :description, :name, :url, :default_send_after_hours, :send_email_without_discount, :user_id

  validates_presence_of :user
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
  validates :url, presence: true, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }
  validates :description, presence: true, length: { maximum: 250 }
  validates :default_send_after_hours, presence: true, numericality: { less_than_or_equal_to: 4320, greater_than_or_equal_to: 0 }

end
