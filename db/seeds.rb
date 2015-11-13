require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ISO3166::Country.all.map do |item|
  Country.create!(name: item[0], alpha2: item[1])
end

if Rails.env == 'development' || Rails.env == 'production' 
  Admin.create!(email: 'admin@mail.com', password: '12345678',
                password_confirmation: '12345678')

  Customer.create!(firstname: "Vadim", lastname: "Tsvid",
                   email: 'vad_1989@mail.ru', password: '12345678',
                   password_confirmation: '12345678',
                   provider: "facebook", uid: "580001345483302")
  Customer.create!(firstname: 'Cus', lastname: 'Tomer', 
                   email: 'customer@mail.com', password: '12345678',
                   password_confirmation: '12345678')

  FactoryGirl.create_list :order_with_order_items, 10
  # FactoryGirl.create_list :book_with_ratings, 10
  FactoryGirl.create_list :category_with_books_with_ratings, 5
end