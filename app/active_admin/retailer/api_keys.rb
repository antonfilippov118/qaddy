ActiveAdmin.register ApiKey, namespace: :retailer do
  menu :priority => 15

  controller do
    def scoped_collection
      ApiKey.where(user_id: current_user.id)
    end
  end

  # controller options
  actions :all, :except => [:new, :destroy, :show]
  config.sort_order = "created_at_desc"
  config.clear_sidebar_sections!
  config.batch_actions = false

  # filters
  filter :key
  filter :created_at
  filter :updated_at

  index do
    column :key
    column("User ID") { |api_key| api_key.user.id }
    column("Enabled", sortable: :enabled) { |api_key| status_tag(api_key.enabled ? "Yes" : "No", api_key.enabled ? :ok : :error) }
    column :created_at
  end

end
