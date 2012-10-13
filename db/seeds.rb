# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

User.create! name: "rumble", email: "rumble@dearfriend.cc", password: "rumble", password_confirmation: "rumble"

3.times { Project.create! name: Faker::Name.name, description: Faker::Lorem::sentences, goal: 100 }
