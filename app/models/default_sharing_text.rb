class DefaultSharingText < ActiveRecord::Base
  belongs_to :webstore
  attr_accessible :active, :text, :use_counter

  validates :text, presence: true, length: { maximum: 250 }
  validates :use_counter, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, where(active: true)
  scope :inactive, where(active: false)
  scope :global_only, where(webstore_id: nil)
end
