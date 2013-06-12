class Topic < ActiveRecord::Base
  attr_accessible :description, :name, :public
  has_many :posts
end
