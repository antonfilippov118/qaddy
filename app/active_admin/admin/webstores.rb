ActiveAdmin.register Webstore do
  config.sort_order = "name_asc"

  filter :user, collection: proc { User.find(:all, order: "LOWER(name) asc") }
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
  end

  form do |f|
    f.inputs do
      f.input :user, collection: User.find(:all, order: "LOWER(name) asc").map{ |user| [user.name, user.id] }
      f.input :name
      f.input :url
      f.input :description
    end
    f.buttons
  end


end
