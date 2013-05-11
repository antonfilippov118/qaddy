class Webstore < ActiveRecord::Base
  belongs_to :user
  has_many :orders, dependent: :destroy
  has_many :email_banners, dependent: :destroy
  has_many :campaigns, dependent: :destroy
  has_many :default_sharing_texts, dependent: :destroy

  attr_accessible :description
  attr_accessible :name
  attr_accessible :url
  attr_accessible :default_send_after_hours
  attr_accessible :send_email_without_discount
  attr_accessible :skip_send_email_for_orders_older_than_days
  attr_accessible :email_sender_name
  attr_accessible :custom_email_subject_with_discount
  attr_accessible :custom_email_html_text_with_discount
  attr_accessible :custom_email_subject_without_discount
  attr_accessible :custom_email_html_text_without_discount
  attr_accessible :custom_email_banner # paperclip attachment
  attr_accessible :custom_email_html_footer
  attr_accessible :user_id

  has_attached_file :custom_email_banner, 
    styles: { thumb: '200x100>', small: '360x180>', medium: '560x280>', big: '780x390>' },
    path: "webstoreemailbanner/:attachment/:id/:style-:hash.:extension",
    :hash_secret => "e663bea571b13acab7309279469ca6a9",
    s3_permissions: :public_read

  validates_presence_of :user
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
  validates :url, presence: true, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }
  validates :description, presence: true, length: { maximum: 250 }
  validates :default_send_after_hours, presence: true, numericality: { less_than_or_equal_to: 4320, greater_than_or_equal_to: 0 }
  validates :skip_send_email_for_orders_older_than_days, presence: true, numericality: { less_than_or_equal_to: 60, greater_than_or_equal_to: 0 }
  validates :email_sender_name, length: { maximum: 50 }

end
