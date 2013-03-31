ActiveAdmin.register ApiKey, namespace: :retailer do
  menu :priority => 5


  controller do
    def scoped_collection
      ApiKey.where(user_id: current_user.id)
    end
  end

  actions :all, :except => [:new, :destroy, :show]

  config.sort_order = "created_at_desc"
  config.clear_sidebar_sections!
  config.batch_actions = false

  filter :key
  filter :created_at
  filter :updated_at

  index do
    column :key
    column("User ID") { |api_key| api_key.user.id }
    column("Enabled", sortable: :enabled) { |api_key| status_tag(api_key.enabled ? "Yes" : "No", api_key.enabled ? :ok : :error) }
    column :created_at
  end

  # show do |api_key|
  #   attributes_table do
  #     row :key
  #     row :enabled do
  #       if api_key.enabled
  #         status_tag("Yes", :ok)
  #       else
  #         status_tag("No", :error)
  #       end
  #     end
  #     row :user
  #     row :created_at
  #     row :updated_at
  #   end
  # end

  # form do |f|
  #   f.semantic_errors *f.object.errors.keys
  #   f.inputs do
  #     f.input :user, input_html: { disabled: true }
  #     f.input :key
  #     f.input :enabled
  #   end
  #   f.actions
  # end

end
