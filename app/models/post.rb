class Post < ActiveRecord::Base
	has_many :comments
	belongs_to :user
	belongs_to :topic
	attr_accessible :body, :title, :topic

	default_scope order('created_at DESC')
end
