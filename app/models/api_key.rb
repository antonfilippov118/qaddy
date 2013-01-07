class ApiKey < ActiveRecord::Base
  belongs_to :user
  attr_accessible :enabled, :key, :user

  before_create :generate_key

  validates_uniqueness_of :user_id  
  validates_presence_of :user
  
  scope :enabled, where(enabled: true)
  scope :disabled, where(enabled: false)

  private
  
    def generate_key
      begin
        self.key = SecureRandom.hex
      end while self.class.exists?(key: key)
    end

end
