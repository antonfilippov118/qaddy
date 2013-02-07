namespace :qaddy do

  desc "Download product images (by 100)"
  task download_product_images: :environment do
    OrderItem.where(product_image_file_name: nil).order(:created_at).limit(100).each do |oi|
      oi.product_image_from_url(oi.image_url)
      oi.save!
    end
  end

  desc "Generate Order and OrderItems's urls (by 100)"
  task generate_short_urls: :environment do
    Order.where(short_url_emailview: nil).order(:created_at).limit(100).each do |o|
      o.generate_short_url_emailview
      o.save!
    end

    Order.where(short_url_doshare: nil).order(:created_at).limit(100).each do |o|
      o.generate_short_url_doshare
      o.save!
    end

    OrderItem.where(short_url_clicked: nil).order(:created_at).limit(100).each do |oi|
      oi.generate_short_url_clicked
      oi.save!
    end
  end

  desc "Send scheduled emails"
  task :send_scheduled_emails, [:destination_email] => :environment do |t, args|
    args.with_defaults(:destination_email => nil)

    # get prepared orders
    orders = Order.where("email_sent_count = 0 AND send_email_at < ? 
                          AND short_url_emailview IS NOT NULL 
                          AND short_url_doshare IS NOT NULL", 
                          DateTime.now).
                          order("created_at ASC").
                          limit(100)

    # check order has all order items prepared
    orders.each do |o|
      complete = true
      o.order_items.each do |oi|
        if oi.product_image.nil? || oi.short_url_clicked.nil?
          complete = false
          break
        end
      end

      # send email and update order if all OK
      if complete
        begin
          ShareMailer.order(o, args.destination_email).deliver
          o.email_sent_count += 1
          o.email_last_sent_at = DateTime.now
          o.save!
        rescue => ex
          logger.error("Error sending an email: #{ex.message}")
        end
      end
    end
  end

end
