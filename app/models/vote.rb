class Vote < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
	attr_accessible :value, :post
	validates :value, inclusion: { in: [-1, 1], message: "%{value} is not a valid vote." }
end
