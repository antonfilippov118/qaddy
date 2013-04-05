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
    default_actions
  end

  show do |webstore|
    attributes_table do
      row :id
      row :name
      row :url
      row :description
      row :email_sender_name
      row :default_send_after_hours
      row :send_email_without_discount do
        if webstore.send_email_without_discount
          status_tag("YES", :error)
        else
          status_tag("No", :ok)
        end
      end
      row :skip_send_email_for_orders_older_than_days
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
      f.input :email_sender_name
      f.input :default_send_after_hours
      f.input :send_email_without_discount
      f.input :skip_send_email_for_orders_older_than_days
    end
    f.actions
  end

end
