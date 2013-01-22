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

end
