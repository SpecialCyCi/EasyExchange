# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rubygems'
require 'csv'
require 'factory_girl'
Dir[Rails.root.join("spec/factories/*.rb")].each {|f| require f}

# 添加初始化学校
puts "INSERT THE SCHOOLS"
CSV.foreach(File.dirname(__FILE__) + "/schools.csv",:headers => true) do |row|
    school = row.to_hash
    puts row.to_hash
    school.delete("id")
    school.delete("created_at")
    school.delete("updated_at")
    school.delete("wechat_users_count")
    school = School.new(name: school["name"])
    school.save
end

puts "INSERT THE USERS"
FactoryGirl.create_list :user, 40

puts "INSERT THE BOOKS"
5.times do
  index = 0
  CSV.foreach(File.dirname(__FILE__) + "/books.csv",:headers => true) do |row|
      book = row.to_hash
      puts row.to_hash
      all_user = User.all.to_a
      FactoryGirl.create :product, name: book["name"], description: book["description"], origin_price: book["origin_price"].to_f, publishing_company: book["publishing_company"], writer: book["writer"], tags: book["tags"], price: book["origin_price"].to_f - rand(1..10), user: all_user.sample, photos: [ FactoryGirl.build(:photo, picture: File.open(Rails.root.join("db", "seeds_data", "books", "#{index}.jpg") ) ) ]
      index = index + 1
  end
end

puts "INSERT COMPLETELY"
