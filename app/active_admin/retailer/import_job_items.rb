#encoding: utf-8

ActiveAdmin.register ImportJobItem, namespace: :retailer do
  belongs_to :import_job
  menu false

  controller do
    def scoped_collection
      ImportJobItem.where(import_job_id: params[:import_job_id])
    end
  end

  # controller options
  scope_to :current_user
  config.sort_order = "created_at_asc"
  config.clear_action_items! # remove all action items (option buttons) as we don't want to show delete button on the show screen. items can be deleted from the index screen only (mass action)
  config.per_page = 10
  actions :all, except: [:edit, :new]

  # Customize filters
  filter :order_number
  filter :order_total
  filter :order_customer_email
  filter :order_customer_name
  filter :order_send_email_at
  filter :order_item_page_url
  filter :order_item_image_url
  filter :order_item_name
  filter :order_item_description
  filter :order_item_total
  filter :order_item_qty
  filter :last_process_date
  filter :last_process_status

  # Customize index screen
  index do
    selectable_column
    column :id, sortable: :id do |import_job_item|
      link_to import_job_item.id, retailer_import_job_import_job_item_url(import_job_item.import_job_id, import_job_item.id)
    end
    column :last_process_status, sortable: :enabled do |item|
      status_tag item.last_process_status
    end

    # column :last_process_status
    column :last_process_date
    column :order_number
    column :order_total
    column :order_customer_email
    column :order_customer_name
    column :order_item_name
    column :created_at
  end

end
