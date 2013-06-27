class UserController < ApplicationController
	def toggle_favorite_email_sender
		temp = !current_user.email_favorites
		current_user.update_attribute(:email_favorites, temp)
		redirect_to :back
	end
end