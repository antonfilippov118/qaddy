class Order < ActiveRecord::Base
  include QaddyHelpers

  belongs_to :webstore
  has_many :order_items, dependent: :destroy, before_add: :set_nested
  accepts_nested_attributes_for :order_items, :allow_destroy => true

  attr_accessible :customer_email
  attr_accessible :customer_name
  attr_accessible :number
  attr_accessible :send_email_after_hours
  attr_accessible :send_email_at
  attr_accessible :total
  attr_accessible :order_items_attributes
  attr_accessible :internal_comment
  attr_accessible :discount_code
  attr_accessible :discount_code_perc
  attr_accessible :tracking_url_params

  before_create :generate_ref_code
  before_create :generate_send_email_at
  before_create :set_campaign

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :customer_email, presence: true, format: { with: VALID_EMAIL_REGEX }, length: { maximum: 200 }
  validates :customer_name, presence: true, length: { maximum: 200 }
  validates_presence_of :number, uniqueness: { scope: :webstore, case_sensitive: false }
  validates_presence_of :total
  validates_presence_of :webstore
  validates :discount_code_perc, allow_nil: true, numericality: { less_than_or_equal_to: 99, greater_than_or_equal_to: 0 }

  scope :no_discount_code, where("discount_code is null or discount_code = ''")
  scope :no_discount_perc, where("discount_code_perc is null or discount_code_perc = 0")
  scope :inactive, where(active: false)

  def display_name
    self.number
  end

  def generate_ref_code
    begin
      self.ref_code = SecureRandom.urlsafe_base64
    end while Order.exists?(ref_code: self.ref_code)
  end

  def generate_short_url_emailview
    set_default_url_options
    bitly = get_bitly_client
    url = Rails.application.routes.url_helpers.share_emailview_url(self.ref_code)
    self.short_url_emailview = bitly.shorten(url).short_url
  end

  def generate_short_url_doshare
    set_default_url_options
    bitly = get_bitly_client
    url = Rails.application.routes.url_helpers.share_doshare_url(self.ref_code)
    self.short_url_doshare = bitly.shorten(url).short_url
  end

  def has_discount?
    self.discount_code_perc.to_i > 0
  end

  private

    def set_nested(order_item)
      order_item.order ||= self
    end

    def generate_send_email_at
      self.send_email_after_hours = self.webstore.default_send_after_hours if self.send_email_after_hours.nil?
      self.send_email_at = DateTime.now.advance(hours: self.send_email_after_hours) if self.send_email_at.nil?
    end

    def set_campaign
      Rails.logger.info "SET_CAMPAIGN:"
      campaign = self.webstore.campaigns.where(active: true).order('created_at desc').first
      Rails.logger.info "CAMPAIGN: #{campaign}"
      if campaign
        self.discount_code = campaign.code
        self.discount_code_perc = campaign.amount
        self.tracking_url_params = campaign.tracking_url_params
      end
    end
end
