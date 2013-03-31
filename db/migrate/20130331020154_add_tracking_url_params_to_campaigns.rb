class AddTrackingUrlParamsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :tracking_url_params, :string
  end
end
