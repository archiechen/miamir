# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
team1 = Team.create! :name =>"Miami"
puts "New team created: " << team1.name

team2 = Team.create! :name =>"Refresh" ,:redmine_project_id=>17
puts "New team created: " << team2.name

puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :email => 'yachuan.chen@chinacache.com', :password => 'woaixuexi', :password_confirmation => 'woaixuexi'
user.teams<<team1
user.save()
puts 'New user created: ' << user.email
user2 = User.create! :email => 'yue.zhang@chinacache.com', :password => 'woaixuexi', :password_confirmation => 'woaixuexi'
user2.teams<<team1
user2.save()
puts 'New user created: ' << user2.email
