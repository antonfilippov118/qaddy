class SignupBeta < ActiveRecord::Base
  attr_accessible :company, :email, :first_name, :ip_address, :last_name, :url

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :company, presence: true, length: { maximum: 200 }
  validates :first_name, presence: true, length: { maximum: 200 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, length: { maximum: 200 }
  validates :url, presence: true, length: { maximum: 200 }

end
