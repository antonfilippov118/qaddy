#encoding: utf-8
require 'csv'

ActiveAdmin.register ImportJob, namespace: :retailer do
  menu :priority => 5

  # customize controller actions
  controller do
    def create
      webstore_id = params[:import_job][:webstore_id]
      csv_file = params[:import_job][:csv_file]
      error = nil
      @import_job = ImportJob.new

      # check if webstore is not null
      if webstore_id.blank?
        @import_job.errors[:webstore_id] << 'no puede estar vacío'
        render :new
        return
      end

      # check if user owns the webstore
      if !current_user.webstores.exists?(id: webstore_id)
        @import_job.errors[:webstore_id] << 'no puede estar vacío'
        render :new
        return
      end

      @import_job.webstore_id = webstore_id

      # check if we have uploaded file
      if csv_file.nil?
        @import_job.errors[:csv_file] << 'no puede estar vacío'
        render :new
        return
      end

      @import_job.filename = csv_file.original_filename

      limit = Rails.application.config.qaddy[:csv_order_import_limit_per_file]
      count = 0

      ActiveRecord::Base.transaction do
        begin
          @import_job.save!
          CSV.foreach(csv_file.tempfile.path, headers: true, header_converters: :symbol) do |row|
            hash = row.to_hash.symbolize_keys
            item = ImportJobItem.new(hash)
            item.import_job = @import_job
            item.save!
            count += 1
            raise "Too many items. There can be up to #{limit} items per CSV file." unless count <= limit
          end
        rescue => e
          error = e.to_s
          Rails.logger.error error;
          @import
          raise ActiveRecord::Rollback
        end
      end

      if error
        @import_job.errors[:import_error] << error
        render :new
        return
      end

      redirect_to retailer_import_job_path(@import_job), 
                  notice: "#{count} items loaded successfully from the '#{@import_job.filename}' file. Please review the items first, then submit the import job."
    end

    def save_job_item_status job_item, status, message
      job_item.last_process_date = DateTime.now
      job_item.last_process_status = status
      job_item.last_process_message = message
      job_item.save
    end

    def save_job_status job, message
      job.last_process_date = DateTime.now
      job.last_process_message = message
      job.save
    end
  end


  # controller options
  scope_to :current_user
  config.sort_order = "created_at_desc"
  config.per_page = 10
  actions :all, except: :edit

  # Customize filters
  filter :webstore, collection: proc { current_user.webstores.order("LOWER(name) asc") }
  filter :filename
  filter :last_process_date
  filter :created_at

  # custom action items
  action_item only: :show do
    link_to('Submit Import Job', submit_retailer_import_job_path(import_job), method: :post, confirm: "You are about to import all the Import Job items. Continue?")
  end

  # Customize index screen
  index do
    selectable_column
    column :filename, sortable: :filename do |import_job|
      link_to import_job.filename, retailer_import_job_path(import_job)
    end
    column "Items" do |import_job|
      import_job.import_job_items.count
      link_to "#{import_job.import_job_items.count} [view items]", retailer_import_job_import_job_items_path(import_job)
    end
    column :webstore
    column :last_process_date
    column :last_process_message
    column :created_at
  end

  # Customize show screen
  show do |import_job|
    attributes_table do
      row :id
      row :filename
      row :webstore
      row :last_process_date
      row :last_process_message
      row "Items" do |import_job|
        link_to "#{import_job.import_job_items.count} [view items]", retailer_import_job_import_job_items_path(import_job)
      end
      row :created_at
    end
  end

  # form screen
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Import Job details" do
      f.input :webstore, collection: current_user.webstores.order("LOWER(name) asc"), as: :select
      f.input :csv_file, label: "CSV File", as: :file
    end
    f.actions
  end

  # custom member actions: submit
  member_action :submit, method: :post do
    job = ImportJob.find(params[:id])
    if job.webstore.user_id != current_user.id
      redirect_to retailer_import_job_path(job), alert: "Unable to find ImportJob."
      return
    end

    cnt_imported = 0
    cnt_exists = 0
    cnt_error = 0

    job.import_job_items.find_each do |job_item|
      # find existing order or create a new one
      order = Order.where(number: job_item.order_number, webstore_id: job.webstore_id).first
      if order.nil?
        order = Order.new(
          number:             job_item.order_number,
          total:              job_item.order_total,
          customer_email:     job_item.order_customer_email,
          customer_name:      job_item.order_customer_name,
          send_email_at:      job_item.order_send_email_at
        )
        order.webstore_id = job.webstore_id
        begin
          order.save!
        rescue => e
          save_job_item_status job_item, "ERROR", "An error occurred: #{e}"
          cnt_error += 1
          next
        end
      end

      # find existing order item or create a new one. skip if we found an existing order item, just save the status message
      item = order.order_items.where(name: job_item.order_item_name, page_url: job_item.order_item_page_url).first
      if item.nil?
        item = OrderItem.new(
          name: job_item.order_item_name,
          description: job_item.order_item_description,
          page_url: job_item.order_item_page_url,
          image_url: job_item.order_item_image_url,
          total: job_item.order_item_total,
          qty: job_item.order_item_qty
        )
        item.order = order
        begin
          item.save!
          save_job_item_status job_item, "OK", "Imported"
          cnt_imported += 1
        rescue => e
          save_job_item_status job_item, "ERROR", "An error occurred: #{e}"
          cnt_error += 1
          next
        end
      else
        save_job_item_status job_item, "OK", "Order item already exists"
        cnt_exists += 1
        next
      end
    end

    msg = "#{cnt_imported} imported; #{cnt_exists} already exist; #{cnt_error} errors."
    save_job_status job, msg
    redirect_to retailer_import_job_path(job), notice: "The import finished: #{msg}"
  end

  # sidebars
  sidebar :help, only: [:new, :create]
end
