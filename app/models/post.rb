class Post < ActiveRecord::Base
	has_many :comments, dependent: :destroy
	has_many :votes, dependent: :destroy
	belongs_to :user
	belongs_to :topic
	attr_accessible :body, :title, :topic

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
end
