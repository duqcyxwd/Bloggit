# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

# rand(10..30).times do
#   p = Post.create(title: Faker::Lorem.words(rand(1..10)).join(' '), body: Faker::Lorem.paragraphs(rand(1..4)).join('\n'))
#   rand(3..10).times do
#     p.comments.create(body: Faker::Lorem.paragraphs(rand(1..2)).join('\n'))
#   end
# end

# puts 'Seed finished'
# puts '#{Post.count} posts created'
# puts '#{Comment.count} comments created"

# Create 15 topics
topics = []
4.times do
  topics << Topic.create(
    name: "Topic Name: #{Faker::Lorem.words(Random.rand(1..10)).join(" ")}", 
    description: "Topic Description: #{Faker::Lorem.paragraph(rand(1..4))}"
  )
end

# Create User
users = []
rand(4..6).times do
	password = Faker::Lorem.characters(10)
	u = User.new(
		name: Faker::Name.name,
		email: Faker::Internet.email,
		password: password,
		password_confirmation: password)
	u.skip_confirmation!
	u.save
	users << u
end

# Create special User
u = User.new(
  name: 'Admin User',
  email: 'admin@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
# u.role = "admin"
u.skip_confirmation!
u.save
u.update_attribute(:role, 'admin')
users << u

u = User.new(
  name: 'Moderator User',
  email: 'moderator@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'moderator')
users << u

u = User.new(
  name: 'Member User',
  email: 'member@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
users << u

u = User.new(
	name:'Super Smart', 
	email: 'duqcyxwd@gmail.com', 
	password: '19095750', 
	password_confirmation: '19095750')
u.skip_confirmation!
u.role = "admin"
u.save
users << u


rand(80..90).times do
    topic = topics.first # getting the first topic here
    u = users.first

	p = u.posts.create(
		topic: topic,
		title: "Post title:#{Faker::Lorem.words(rand(1..6)).join(" ")}",
		body: "Post body:#{Faker::Lorem.paragraphs(rand(1..4)).join("\n")}" )
	# set the created_at to a time within the past year
	p.update_attribute(:created_at, Time.now - rand(600..31536000))
    p.update_rank
    
    users.rotate!
	topics.rotate! # add this line to move the first topic to the last, so that posts get assigned to different topics.
end

c1 = "##Hi, Everyone, I want show some ruby code

```ruby
    def Hello 
        puts \"Hello World!\"
    end
```

<code lang='ruby'>
puts 'Hello, world'
</code>

Hi, We have one `Code` Hahaha

More ruby code

```ruby
module ApplicationHelper
	def control_group_tag(errors, &block)
		if errors.any?
			content_tag :div, capture(&block), class: 'control-group error'
		else
			content_tag :div, capture(&block), class: 'control-group'
		end
	end

	class MarkdownRenderer < Redcarpet::Render::HTML
		def block_code(code, language)
			# CodeRay.highlight(code, language, :line_numbers => :table)
			# CodeRay.highlight(code, language)
			# CodeRay.scan(code, language).div
			# CodeRay.scan(code, language).div(:line_numbers => :table)
			CodeRay.scan(code, language||'ruby').html(:line_numbers => :table)
		end
	end

	def markdown(text)
		rndr = MarkdownRenderer.new(:filter_html => false, :hard_wrap => false)
		options = {
			:fenced_code_blocks => true,
			:no_intra_emphasis => true,
			:autolink => true,
			:strikethrough => true,
			:lax_html_blocks => true,
			:superscript => true
		}
		markdown_to_html = Redcarpet::Markdown.new(rndr, options)
		markdown_to_html.render(text).html_safe
	end

	# def markdown(text)
	# 	renderer = Redcarpet::Render::HTML.new
	# 	extensions = {fenced_code_blocks: true}
	# 	redcarpet = Redcarpet::Markdown.new(renderer, extensions)
	# 	(redcarpet.render text).html_safe
	# end
end

```"



topic = Topic.create(
    name: "Code SyntaxHighlighting Example", 
    description: "This is a special section to demonstrate Markdown and SyntaxHighlighting"
  )

p = u.posts.create(
	topic: topic,
	title: "Some Ruby Code",
	body: "#{c1}" )
# set the created_at to a time within the past year
p.update_attribute(:created_at, Time.now)



##Create comments
post_count = Post.count
User.all.each do |user|
  rand(30..50).times do
    p = Post.find(rand(1..post_count))
    c = user.comments.create(
      body: Faker::Lorem.paragraphs(rand(1..2)).join("\n"),
      post: p)
    c.update_attribute(:created_at, Time.now - rand(600..31536000))
  end
end

##Create Votes
post_count = Post.count
User.all.each do |user|
  rand(20..100).times do
  	v = [1, 1, 1, -1].sample
    p = Post.find(rand(1..post_count))
    if user.votes.where(post_id: p.id).first
    	user.votes.where(post_id: p.id).first.update_attribute(:value, v)
    	user.votes.where(post_id: p.id).first.update_post
    else
	    user.votes.create(value: v, post: p)
    end
  end
end


puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{User.count} users created"
puts "#{Topic.count} topics created"