# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rubygems'
require 'csv'

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
puts "INSERT COMPLETELY"
