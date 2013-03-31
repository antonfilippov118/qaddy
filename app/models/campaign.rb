class Campaign < ActiveRecord::Base
  belongs_to :webstore
  attr_accessible :active, :amount, :code, :name, :tracking_url_params

  before_save :cleanup_tracking_url_params

  validates_presence_of :webstore
  validates_presence_of :code
  validates_presence_of :name
  validates_presence_of :amount
  validates :amount, presence: true, numericality: { less_than_or_equal_to: 99, greater_than_or_equal_to: 1 }

  scope :active, where(active: true)
  scope :inactive, where(active: false)

  def user
    (!self.webstore.nil? && self.webstore.user) || nil
  end


  private

    # let the user paste the whole URL
    # also need to handle the editing of already saved params
    def cleanup_tracking_url_params
      begin
        self.tracking_url_params = self.tracking_url_params.to_s.strip
        uri = URI.parse(self.tracking_url_params)
        if uri.scheme.nil? && uri.hostname.nil? && uri.query.nil?
          if self.tracking_url_params[0,1] != "?"
            uri = URI.parse("?#{self.tracking_url_params}")
          end
        end
        self.tracking_url_params = uri.query
      rescue
        self.tracking_url_params = nil
      end
    end

end
