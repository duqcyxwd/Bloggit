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
		p = u.posts.create(
		title: Faker::Lorem.words(rand(1..10)).join(" "),
		body: Faker::Lorem.paragraphs(rand(1..4)).join("\n"))
		# set the created_at to a time within the past year
		p.update_attribute(:created_at, Time.now - rand(600..31536000))

		rand(3..7).times do
			p.comments.create(
			body: Faker::Lorem.paragraphs(rand(1..2)).join("\n"))
		end
	end
end

u = User.first
u.update_attributes(email: 'duqcyxwd@gmail.com', password: '19095750', password_confirmation: '19095750')
u.confirm!

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{User.count} users created"
