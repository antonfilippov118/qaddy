class ShareMailer < ActionMailer::Base
  include QaddyHelpers

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
    bcc = Rails.application.config.qaddy[:webstore_email_bcc]
    from_email = webstore_send_from_email(@order.webstore)
    mail(from: from_email, to: email_destination, bcc: bcc, subject: "Tu compra en #{order.webstore.name}")
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
