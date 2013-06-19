class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  attr_accessible :body, :post, :user

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true
end
