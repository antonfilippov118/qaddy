ActiveAdmin.register Campaign, namespace: :retailer do
  menu :priority => 3

  # customize controller actions
  controller do
    def update
      @campaign = Campaign.find(params[:id])
      webstore_id = params[:campaign][:webstore_id]
      params[:campaign].except!(:webstore_id)
      @campaign.assign_attributes params[:campaign]
      @campaign.webstore_id = webstore_id

      # check if webstore pertain to the current user
      if !webstore_id.blank? && !current_user.webstores.exists?(webstore_id)
        @campaign.errors[:webstore_id] << 'is not correct'
        render :edit
        return
      end

      update!
    end

    def create
      webstore_id = params[:campaign][:webstore_id]
      params[:campaign].except!(:webstore_id)
      @campaign = Campaign.new(params[:campaign])
      @campaign.webstore_id = webstore_id

      # check if webstore pertain to the current user
      if !webstore_id.blank? && !current_user.webstores.exists?(webstore_id)
        @campaign.errors[:webstore_id] << 'is not correct'
        render :new
        return
      end

      create!
    end
  end


  # controller options
  scope_to :current_user
  config.sort_order = "created_at_desc"
  actions :all

  # filters
  filter :webstore, collection: proc { current_user.webstores.order("LOWER(name) asc") }
  filter :name
  filter :code
  filter :amount
  filter :tracking_url_params
  filter :created_at
  filter :updated_at

  # scopes
  scope :all, :default => true
  scope :active
  scope :inactive

  # index screen
  index do
    selectable_column
    column :name, sortable: :name do |campaign|
      link_to campaign.name, retailer_campaign_path(campaign)
    end
    column :code
    column :amount
    column :webstore
    column("Active", sortable: :active) { |campaign| status_tag("Active", :ok) unless !campaign.active? }
    column :created_at
    default_actions
  end

  # show screen
  show do |campaign|
    attributes_table do
      row :id
      row :name
      row :code
      row :amount
      row :webstore
      row :active do
        if campaign.active
          status_tag("Active", :ok)
        else
          status_tag("No")
        end
      end
      row :tracking_url_params
      row :created_at
      row :updated_at
    end
  end

  # form screen
  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Campaign details" do
      f.input :webstore, collection: current_user.webstores.order("LOWER(name) asc"), as: :select
      f.input :name
      f.input :code
      f.input :amount
      f.input :active
      f.input :tracking_url_params
    end

    f.actions
  end

end
