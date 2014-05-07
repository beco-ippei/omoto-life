# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.new do |u|
  u.id  = 1
  u.name =  'いっぺい'
  u.age =  35
  u.email = 'ippei@mail.com'
  u.password = '0000'
  u.password_confirmation = '0000'
end.save!

