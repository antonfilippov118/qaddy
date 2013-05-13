class ImportJob < ActiveRecord::Base
  belongs_to :webstore
  has_many :import_job_items, dependent: :destroy

  attr_accessible :filename, :last_process_date, :last_process_message, :submitted

  def display_name
    "Import Job ##{self.id}"
  end

end
