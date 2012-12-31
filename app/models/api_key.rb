class ApiKey < ActiveRecord::Base
  belongs_to :user
  attr_accessible :enabled, :key, :user

  before_create :generate_key
  
  private
  
    def generate_key
      begin
        self.key = SecureRandom.hex
      end while self.class.exists?(key: key)
    end

end
