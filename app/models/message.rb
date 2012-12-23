# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ActiveRecord::Base
  attr_accessible :email

  validates :email, :presence => true
  validates :email, :format => { :with => %r{.+@.+\..+} }, :allow_blank => false
  
  # def initialize(attributes = {})
  #   attributes.each do |name, value|
  #     send("#{name}=", value)
  #   end
  # end

end
