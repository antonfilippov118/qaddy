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
  attr_accessible :email, :name, :password, :password_confirmation, :no_password
  attr_accessor :no_password

  has_secure_password

  before_save { self.email.downcase! }
  before_save :create_remember_token, unless: :no_password

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, unless: :no_password
  validates :password_confirmation, presence: true, unless: :no_password

  scope :admin, where(admin: true)
  scope :non_admin, where(admin: false)

  def send_password_reset
    create_password_reset
    UserMailer.password_reset(self).deliver
  end

  def create_password_reset
    generate_password_reset_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    self.no_password = true
    save!(validate: false)
    self.no_password = nil
    return self[:password_reset_token]
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
