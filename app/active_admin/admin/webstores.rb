ActiveAdmin.register Webstore do
  menu :priority => 3

  config.sort_order = "name_asc"

  filter :user, collection: User.order("LOWER(name) asc")
  filter :name
  filter :url
  filter :description
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :name, sortable: :name do |webstore|
      link_to webstore.name, admin_webstore_path(webstore)
    end
    column :url
    column :user
    column :created_at
    default_actions
  end

  show do |webstore|
    attributes_table do
      row :id
      row :name
      row :url
      row :description
      row :user
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
      row :custom_email_subject_with_discount
      row :custom_email_html_text_with_discount
      row :custom_email_subject_without_discount
      row :custom_email_html_text_without_discount
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :user, collection: User.order("LOWER(name) asc").map{ |user| [user.name, user.id] }
      f.input :name
      f.input :url
      f.input :description
      f.input :email_sender_name
      f.input :default_send_after_hours
      f.input :send_email_without_discount
      f.input :skip_send_email_for_orders_older_than_days
      f.input :custom_email_subject_with_discount
      f.input :custom_email_html_text_with_discount
      f.input :custom_email_subject_without_discount
      f.input :custom_email_html_text_without_discount
    end
    f.actions
  end

end
