class OrderItem < ActiveRecord::Base
  include QaddyHelpers

  belongs_to :order

  attr_accessible :default_sharing_text
  attr_accessible :description
  attr_accessible :image_url
  attr_accessible :name
  attr_accessible :page_url
  attr_accessible :qty
  attr_accessible :total
  attr_accessible :product_image # paperclip attachment, downloaded product image from image_url

  has_attached_file :product_image, 
    styles: { thumb: '100x100>', small: '200x200>', medium: '300x300>', big: '500x500>' },
    path: "orderitem/:attachment/:id/:style.:extension",
    s3_permissions: :private

  before_create :generate_ref_code

  VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

  validates :image_url, presence: true, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }
  validates :name, presence: true, length: { maximum: 200 }
  validates :page_url, presence: true, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }
  validates_presence_of :order

  def product_image_from_url(url)
    self.product_image = URI.parse(url)
  end  

  def generate_ref_code
    begin
      self.ref_code = SecureRandom.urlsafe_base64
    end while OrderItem.exists?(ref_code: self.ref_code)
  end

  def generate_short_url_clicked
    set_default_url_options
    bitly = get_bitly_client
    url = Rails.application.routes.url_helpers.share_clicked_url(self.ref_code)
    self.short_url_clicked = bitly.shorten(url).short_url
  end

end
