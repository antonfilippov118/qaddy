namespace :db do

  desc "Fill databaes with sample data"
  task populate: :environment do
    admin = User.create!(
      name: "Example User",
      email: "example@example.com",
      password: "123123",
      password_confirmation: "123123")
    admin.toggle!(:admin)

    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@example.com"
      password = "password"
      User.create!(
        name: name,
        email: email,
        password: password,
        password_confirmation: password)
    end
  end

end