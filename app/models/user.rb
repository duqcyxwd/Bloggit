class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise  :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable,
    :omniauthable, :omniauth_providers => [:facebook]

    # Setup accessible (or protected) attributes for your model

    attr_accessible :email, :password, :password_confirmation,
    :remember_me, :name, :avatar, :provider, :uid, :email_favorites

    has_many :posts
    has_many :comments
    has_many :votes, dependent: :destroy
    has_many :favorites, dependent: :destroy

    before_create :set_default_role

    mount_uploader :avatar, AvatarUploader # add this line.

    def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
        user = User.where(:provider => auth.provider, :uid => auth.uid).first
        unless user
            pass = Devise.friendly_token[0,20]
            user = User.new(name:auth.extra.raw_info.name,
            provider:auth.provider,
            uid:auth.uid,
            email:auth.info.email,
            password: pass,
            password_confirmation: pass
            )
            user.skip_confirmation!
            user.save
        end
        user
    end

    # attr_accessible :title, :body
    ROLES = %w[member moderator admin]
    def role?(base_role)
        role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
    end

    def favorited(post)
        self.favorites.where(post_id: post.id).first
    end

    def voted(post)
        self.votes.where(post_id: post.id).first
    end

    private

    def set_default_role
        self.role ||= 'member'
    end
end
