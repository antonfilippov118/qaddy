ActiveAdmin.register ApiKey do
  menu :priority => 5

  actions :all, :except => [:new, :destroy]

  config.sort_order = "created_at_desc"

  filter :user
  filter :key
  filter :created_at
  filter :updated_at

  scope :all, :default => true
  scope :enabled
  scope :disabled

  index do
    selectable_column
    column :key, sortable: :key do |api_key|
      link_to api_key.key, admin_api_key_path(api_key)
    end
    column :user
    column("Enabled", sortable: :enabled) { |api_key| status_tag(api_key.enabled ? "Yes" : "No", api_key.enabled ? :ok : :error) }
    column :created_at
  end

  show do |api_key|
    attributes_table do
      row :id
      row :key
      row :enabled do
        if api_key.enabled
          status_tag("Yes", :ok)
        else
          status_tag("No", :error)
        end
      end
      row :user
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :user, input_html: { disabled: true }
      f.input :key
      f.input :enabled
    end
    f.actions
  end

end
