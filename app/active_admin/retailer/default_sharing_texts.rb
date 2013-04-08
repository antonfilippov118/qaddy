#encoding: utf-8
ActiveAdmin.register DefaultSharingText, namespace: :retailer do
  menu :priority => 5

  # customize controller actions
  controller do
    def update
      @default_sharing_text = DefaultSharingText.find(params[:id])
      webstore_id = params[:default_sharing_text][:webstore_id]
      params[:default_sharing_text].except!(:webstore_id)
      @default_sharing_text.assign_attributes params[:default_sharing_text]
      @default_sharing_text.webstore_id = webstore_id

      # check if webstore pertain to the current user
      if !webstore_id.blank? && !current_user.webstores.exists?(webstore_id)
        @default_sharing_text.errors[:webstore_id] << 'is not correct'
        render :edit
        return
      end

      update!
    end

    def create
      webstore_id = params[:default_sharing_text][:webstore_id]
      params[:default_sharing_text].except!(:webstore_id)
      @default_sharing_text = DefaultSharingText.new(params[:default_sharing_text])
      @default_sharing_text.webstore_id = webstore_id

      # check if webstore is not null (for retailers)
      if webstore_id.blank?
        @default_sharing_text.errors[:webstore_id] << 'no puede estar vacío'
        render :new
        return
      end
      # check if webstore pertain to the current user
      if webstore_id.present? && !current_user.webstores.exists?(webstore_id)
        @default_sharing_text.errors[:webstore_id] << 'is not correct'
        render :new
        return
      end

      create!
    end
  end


  # controller options
  scope_to :current_user
  config.sort_order = "created_at_asc"
  actions :all

  # filters
  filter :webstore, collection: proc { current_user.webstores.order("LOWER(name) asc") }
  filter :text
  filter :use_counter
  filter :active
  filter :created_at
  filter :updated_at

  # scopes
  scope :all, :default => true
  scope :active
  scope :inactive

  # index screen
  index do
    selectable_column
    column :text, sortable: :text do |default_sharing_text|
      link_to default_sharing_text.text, retailer_default_sharing_text_path(default_sharing_text)
    end
    column :webstore
    column("Active", sortable: :active) { |default_sharing_text| status_tag("Active", :ok) unless !default_sharing_text.active? }
    column :use_counter
    column :created_at
  end

  # show screen
  show do |default_sharing_text|
    attributes_table do
      row :id
      row :text
      row :webstore
      row :active do
        if default_sharing_text.active
          status_tag("Active", :ok)
        else
          status_tag("No")
        end
      end
      row :use_counter
      row :created_at
      row :updated_at
    end
  end

  # form screen
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Default Sharing Text details" do
      f.input :webstore, collection: current_user.webstores.order("LOWER(name) asc"), as: :select
      f.input :text
      f.input :use_counter
      f.input :active
    end
    f.actions
  end

end
