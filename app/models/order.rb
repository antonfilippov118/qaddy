class Order < ActiveRecord::Base
  belongs_to :webstore
  has_many :order_items, before_add: :set_nested
  accepts_nested_attributes_for :order_items

  attr_accessible :customer_email
  attr_accessible :customer_name
  attr_accessible :default_sharing_text
  attr_accessible :discount_code_perc
  attr_accessible :number
  attr_accessible :send_email_after_hours
  attr_accessible :send_email_at
  attr_accessible :total
  attr_accessible :order_items_attributes

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :customer_email, presence: true, format: { with: VALID_EMAIL_REGEX }, length: { maximum: 200 }
  validates :customer_name, presence: true, length: { maximum: 200 }
  validates_presence_of :number, uniqueness: { scope: :webstore, case_sensitive: false }
  validates_presence_of :total
  validates_presence_of :webstore

  private

    def set_nested(order_item)
      order_item.order ||= self
    end

end
