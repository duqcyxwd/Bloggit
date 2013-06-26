class Post < ActiveRecord::Base
	# The final thing to implement is default voting. It's safe to assume that if a user submits a post, they'll want to vote it up
	# We'll do this automatically for them by adding another after_create in post.rb:
	after_create :create_vote

	has_many :comments, dependent: :destroy
	has_many :votes, dependent: :destroy
	has_many :favorites, dependent: :destroy
	
	belongs_to :user
	belongs_to :topic
	mount_uploader :image, PostImageUploader

	attr_accessible :body, :title, :topic, :user, :image

	# created_at is a clown in database
	# default_scope order('created_at DESC')
	default_scope order('rank DESC') # Da dao xiao

	validates :title, length: { minimum: 5 }, presence: true
	validates :body, length: { minimum: 20 }, presence: true
	validates :topic, presence: true
	validates :user, presence: true

	def up_votes_count
		self.votes.where(value: 1).count
	end

	def down_votes_count
		self.votes.where(value: -1).count
	end

	def points
		self.votes.sum(:value).to_i
	end

	def update_rank
		new_rank = points
		age = (Time.now - self.created_at) / 86400
		new_rank -= (age * 5) if age > 4

		self.update_attribute(:rank, new_rank)
	end


	private

	# Who ever created a post, should automatically be set to "voting" it up.
	def create_vote
		user.votes.create(value: 1, post: self)
	end

end
