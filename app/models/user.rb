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

  has_many :webstores, dependent: :destroy
  has_one :api_key, dependent: :destroy
  has_many :campaigns, through: :webstores
  has_many :default_sharing_texts, through: :webstores

  has_secure_password

  before_validation :check_empty_digest
  before_save { self.email.downcase! }
  before_save :create_remember_token, unless: :no_password
  after_create :create_api_key

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

    # This is for case when creating new user without password (e.g. from Admin)
    def check_empty_digest
      logger.debug("check_empty_digest")
      if self.no_password.is_a?(TrueClass) || self.no_password == "1"
        if self.password.to_s.empty? && self.password_confirmation.to_s.empty? && self.password_digest.to_s.empty?
          self.password = SecureRandom.urlsafe_base64
          self.password_confirmation = self.password
          create_remember_token
        end
      end
    end

    def create_api_key
      ApiKey.create!(enabled: true, user: self)
    end

end
