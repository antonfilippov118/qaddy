ActiveAdmin.register User do
  config.sort_order = "created_at_desc"

  filter :name
  filter :email
  filter :created_at
  filter :updated_at

  scope :all, :default => true
  scope :admin
  scope :non_admin

  index do
    selectable_column
    # id_column
    column :name, sortable: :name do |user|
      link_to user.name, admin_user_path(user)
    end
    column :email
    column("Admin", sortable: :admin) { |user| status_tag("Admin", :ok) unless !user.admin? }
    column :created_at
    # column :updated_at
    # default_actions
  end

  show do |user|
    attributes_table do
      row :id
      row :name
      row :email
      row :created_at
      row :updated_at
      row :admin do
        if user.admin
          status_tag("Yes", :ok)
        else
          status_tag("No")
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      # probably need to create a custom action here to avoid mass-assign error
      # f.input :admin
    end
    f.buttons
  end

end
