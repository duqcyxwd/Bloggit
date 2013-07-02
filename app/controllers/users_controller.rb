class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
		# @posts = @user.posts
		@posts = @user.posts.public(current_user)
		# @posts = Topic.public(current_user).paginate(page: params[:page], per_page: 10)
	end

	def toggle_favorite_email_sender
		temp = !current_user.email_favorites
		current_user.update_attribute(:email_favorites, temp)
		redirect_to :back
	end
end