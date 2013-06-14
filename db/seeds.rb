# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

# rand(10..30).times do
#   p = Post.create(title: Faker::Lorem.words(rand(1..10)).join(" "), body: Faker::Lorem.paragraphs(rand(1..4)).join("\n"))
#   rand(3..10).times do
#     p.comments.create(body: Faker::Lorem.paragraphs(rand(1..2)).join("\n"))
#   end
# end

# puts "Seed finished"
# puts "#{Post.count} posts created"
# puts "#{Comment.count} comments created"

# Create 15 topics
topics = []
6.times do
  topics << Topic.create(
    name: "Topic Name: #{Faker::Lorem.words(rand(1..10)).join(" ")}", 
    description: "Topic Description: #{Faker::Lorem.paragraph(rand(1..4))}"
  )
end



rand(4..10).times do
	password = Faker::Lorem.characters(10)
	u = User.new(
		name: Faker::Name.name,
		email: Faker::Internet.email,
		password: password,
		password_confirmation: password)
	u.skip_confirmation!
	u.save

	rand(5..12).times do
	    topic = topics.first # getting the first topic here
		p = u.posts.create(
			topic: topic,
			title: "Post title:#{Faker::Lorem.words(rand(1..10)).join(" ")}",
			body: "Post body:#{Faker::Lorem.paragraphs(rand(1..4)).join("\n")}" )
		# set the created_at to a time within the past year
		p.update_attribute(:created_at, Time.now - rand(600..31536000))

		rand(3..7).times do
			p.comments.create(
				body: Faker::Lorem.paragraphs(rand(1..2)).join("\n"))
		end

		topics.rotate! # add this line to move the first topic to the last, so that posts get assigned to different topics.
	end
end

u = User.find(1)
u.update_attributes(name:'Super Smart', email: 'duqcyxwd@gmail.com', password: '19095750', password_confirmation: '19095750')
u.role = "admin"
# u.confirm!
u.skip_confirmation!
u.save

u = User.new(
  name: 'Admin User',
  email: 'admin@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'admin')

u = User.new(
  name: 'Moderator User',
  email: 'moderator@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'moderator')

u = User.new(
  name: 'Member User',
  email: 'member@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save


puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{User.count} users created"
puts "#{topics.count} topics created"
