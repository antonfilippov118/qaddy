class ShareMailer < ActionMailer::Base
  include QaddyHelpers

  # send order details with sharing link and discount info if present
  def order(order, email_destination = nil)
    @order = order
    @email_banner = @order.webstore.email_banners.where(active: true).first

    # predefined subject,text
    @subject = "Tu compra en #{order.webstore.name}"
    @text    = "Comparte tu reciente compra en <b>#{@order.webstore.name}</b> en las redes sociales!"
    if @order.has_discount?
      @text = "Comparte tu reciente compra en <b>#{@order.webstore.name}</b> en las redes sociales y recibe un <b>#{@order.discount_code_perc.to_i}% de descuento</b> en tu siguiente compra!"
    end

    # check for custom subject,text
    if @order.has_discount?
      @subject = @order.webstore.custom_email_subject_with_discount unless @order.webstore.custom_email_subject_with_discount.blank?
      @text    = @order.webstore.custom_email_html_text_with_discount unless @order.webstore.custom_email_html_text_with_discount.blank?
    else
      @subject = @order.webstore.custom_email_subject_without_discount unless @order.webstore.custom_email_subject_without_discount.blank?
      @text    = @order.webstore.custom_email_html_text_without_discount unless @order.webstore.custom_email_html_text_without_discount.blank?
    end

    # make text replacements, if any
    @text = @text.gsub('{order.discount_code_perc}', @order.discount_code_perc.to_i.to_s)

    if (@email_banner)
      att = Paperclip.io_adapters.for(@email_banner.banner.styles[:medium])
      attachments.inline["banner#{File.extname(@email_banner.banner_file_name)}"] = File.read(att.path)
    end

    @order.order_items.each do |oi|
      att = Paperclip.io_adapters.for(oi.product_image.styles[:small])
      attachments.inline["#{oi.id}#{File.extname(oi.product_image_file_name)}"] = {
        mime_type: oi.product_image_content_type,
        content: File.read(att.path)
      }
    end

    email_destination ||= order.customer_email
    bcc = Rails.application.config.qaddy[:webstore_email_bcc]
    from_email = webstore_send_from_email(@order.webstore)
    mail(from: from_email, to: email_destination, bcc: bcc, subject: @subject)
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
    bcc = Rails.application.config.qaddy[:webstore_email_bcc]
    from_email = webstore_send_from_email(@order.webstore)
    mail(from: from_email, to: email_destination, bcc: bcc, subject: "Tu compra en #{order.webstore.name} - Gracias por compartir!")
  end
end
