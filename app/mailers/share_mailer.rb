class ShareMailer < ActionMailer::Base

  # send order details with sharing link and discount info if present
  def order(order, email_destination = nil)
    @order = order
    @email_banner = @order.webstore.email_banners.where(active: true).first

    if (@email_banner)
      att = Paperclip.io_adapters.for(@email_banner.banner.styles[:medium])
      attachments.inline["banner#{File.extname(@email_banner.banner_file_name)}"] = File.read(att.path)
    end

    @order.order_items.each do |oi|
      att = Paperclip.io_adapters.for(oi.product_image.styles[:small])
      attachments.inline["#{oi.id}#{File.extname(oi.product_image_file_name)}"] = File.read(att.path)
    end

    email_destination ||= order.customer_email
    mail(to: email_destination, subject: "Tu compra en #{order.webstore.name}")
  end

  # send discount code
  def discount_code(order, email_destination = nil)
    @order = order
    @email_banner = @order.webstore.email_banners.where(active: true).first

    if (@email_banner)
      att = Paperclip.io_adapters.for(@email_banner.banner.styles[:medium])
      attachments.inline["banner#{File.extname(@email_banner.banner_file_name)}"] = File.read(att.path)
    end

    email_destination ||= order.customer_email
    mail(to: email_destination, subject: "Tu compra en #{order.webstore.name} - Gracias por compartir!")
  end
end
