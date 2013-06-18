# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# admin user
ua = User.find_by_email('admin@example.com')
ua ||= User.new(name: 'Admin User', email: 'admin@example.com')
ua.admin = true
ua.password = '123123'
ua.password_confirmation = '123123'
ua.save!
ua.api_key.key = '16abcd7c21697504d19198470cbc409b'
ua.api_key.enabled = true
ua.api_key.save!




# retailer user 1
u1 = User.find_by_email('retail_1@example.com')
u1 ||= User.new(name: 'Retail User 1', email: 'retail_1@example.com')
u1.admin = false
u1.password = '123123'
u1.password_confirmation = '123123'
u1.save!
u1.api_key.key = '246e9ed42db87305dc7026d8db72be72'
u1.api_key.enabled = true
u1.api_key.save!

# webstore 1 - user 1
pref = "11"
w11 = u1.webstores.find_by_name('User 1\'s Webstore 1')
w11 ||= u1.webstores.create!(name: 'User 1\'s Webstore 1', url: "http://www#{pref}.example.com/", description: 'User 1\'s Webstore 1', default_send_after_hours: 120, skip_send_email_for_orders_older_than_days: 60)

# webstore 1 - user 1 orders
numorders = 100
numorderitemsmax = 10
w11.orders.delete_all
numorders.times do |n|
  o = w11.orders.create!(number: "#{pref}-o#{n}", total: 10.50+n*0.5, customer_email: "#{pref}-o#{n}@example.com", customer_name: "#{pref}-o#{n} Example")
  o.email_sent_count = 1
  o.email_read_count = 1
  o.created_at = ((n-numorders)*43).abs.hours.ago - (rand*2520).minutes
  o.email_read_count = (rand*5).to_i
  o.save!

  ((n / numorderitemsmax) + 1).times do |m|
    oi = o.order_items.create!(page_url: "http://www#{pref}.example.com/product/#{m}", image_url: "http://www#{pref}.example.com/image/#{m}", name: "Product #{m}")
    oi.share_count = (rand*2).to_i
    oi.click_count = oi.share_count * (rand*50)
    oi.save!
  end
end




# retailer user 2
u2 = User.find_by_email('retail_2@example.com')
u2 ||= User.new(name: 'Retail User 2', email: 'retail_2@example.com')
u2.admin = false
u2.password = '123123'
u2.password_confirmation = '123123'
u2.save!
u2.api_key.key = '05c730ef6623ab61760ba9ee3c2c16b2'
u2.api_key.enabled = true
u2.api_key.save!

# webstore 1 - user 2
pref = "12"
w12 = u2.webstores.find_by_name('User 2\'s Webstore 1')
w12 ||= u2.webstores.create!(name: 'User 2\'s Webstore 1', url: "http://www#{pref}.example.com/", description: 'User 2\'s Webstore 1', default_send_after_hours: 120, skip_send_email_for_orders_older_than_days: 60)

# webstore 1 - user 2 orders
numorders = 100
numorderitemsmax = 10
w12.orders.delete_all
numorders.times do |n|
  o = w12.orders.create!(number: "#{pref}-o#{n}", total: 10.50+n*0.5, customer_email: "#{pref}-o#{n}@example.com", customer_name: "#{pref}-o#{n} Example")
  o.email_sent_count = 1
  o.email_read_count = 1
  o.created_at = ((n-numorders)*43).abs.hours.ago - (rand*2520).minutes
  o.email_read_count = (rand*5).to_i
  o.save!

  ((n / numorderitemsmax) + 1).times do |m|
    oi = o.order_items.create!(page_url: "http://www#{pref}.example.com/product/#{m}", image_url: "http://www#{pref}.example.com/image/#{m}", name: "Product #{m}")
    oi.share_count = (rand*3).to_i
    oi.click_count = oi.share_count * (rand*50)
    oi.save!
  end
end


# webstore 2 - user 2
pref = "22"
w22 = u2.webstores.find_by_name('User 2\'s Webstore 2')
w22 ||= u2.webstores.create!(name: 'User 2\'s Webstore 2', url: "http://www#{pref}.example.com/", description: 'User 2\'s Webstore 2', default_send_after_hours: 120, skip_send_email_for_orders_older_than_days: 60)

# webstore 2 - user 2 orders
numorders = 100
numorderitemsmax = 10
w22.orders.delete_all
numorders.times do |n|
  o = w22.orders.create!(number: "#{pref}-o#{n}", total: 10.50+n*0.5, customer_email: "#{pref}-o#{n}@example.com", customer_name: "#{pref}-o#{n} Example")
  o.email_sent_count = 1
  o.email_read_count = 1
  o.created_at = ((n-numorders)*43).abs.hours.ago - (rand*2520).minutes
  o.email_read_count = (rand*5).to_i
  o.save!

  ((n / numorderitemsmax) + 1).times do |m|
    oi = o.order_items.create!(page_url: "http://www#{pref}.example.com/product/#{m}", image_url: "http://www#{pref}.example.com/image/#{m}", name: "Product #{m}")
    oi.share_count = (rand*2).to_i
    oi.click_count = oi.share_count * (rand*50)
    oi.save!
  end
end
