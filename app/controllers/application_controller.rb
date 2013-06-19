class ApplicationController < ActionController::Base
	protect_from_forgery

	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_url, :alert => exception.message
	end

	#Require you to be login first
	# before_filter :authenticate_user!

	after_filter :store_refer

	def store_refer
		session[:user_return_to] = request.referrer
	end

	def after_sign_in_path_for(resource)
		session[:user_return_to] || root_path
	end

	def after_sign_out_path_for(resource_or_scope)
		request.referrer
	end
end
