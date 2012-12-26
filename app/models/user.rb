# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  has_secure_password

  before_save { self.email.downcase! }
  before_save :create_remember_token

  scope :admin, where(admin: true)
  scope :non_admin, where(admin: false)

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def send_password_reset
    generate_password_reset_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false, callbacks: false)
    UserMailer.password_reset(self).deliver
  end

  def generate_password_reset_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end



end
