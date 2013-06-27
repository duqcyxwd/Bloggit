class Topic < ActiveRecord::Base
	attr_accessible :description, :name, :public
	has_many :posts, dependent: :destroy
	scope :public, lambda { |user| user ? scoped : where(public: true) }
end
