ActiveAdmin.register Webstore, namespace: :retailer do
  menu :priority => 2

  scope_to :current_user

  config.sort_order = "name_asc"
  config.batch_actions = false

  filter :name
  filter :url
  filter :description
  filter :created_at
  filter :updated_at

  index do
    column :name, sortable: :name do |webstore|
      link_to webstore.name, retailer_webstore_path(webstore)
    end
    column :url
    column :description
  end

  show do |webstore|
    attributes_table do
      row :id
      row :name
      row :url
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :url
      f.input :description
    end
    f.actions
  end

end
