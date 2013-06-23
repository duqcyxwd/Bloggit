class ApplicationController < ActionController::Base
	protect_from_forgery

	rescue_from CanCan::AccessDenied do |exception|
		# redirect_to root_url, :alert => exception.message
		redirect_to request.referrer || root_path, :alert => exception.message
	end

	#save a location after page finish loading, use this to redirect user to original page after user sign in
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
