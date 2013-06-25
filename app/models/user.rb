class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, :confirmable,
          :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :avatar, :provider, :uid

  has_many :posts
  has_many :comments
  has_many :votes, dependent: :destroy

  before_create :set_default_role

  mount_uploader :avatar, AvatarUploader # add this line.

  # attr_accessible :title, :body
  ROLES = %w[member moderator admin]
  def role?(base_role)
    role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  private

  def set_default_role
    self.role ||= 'member'
  end
end
