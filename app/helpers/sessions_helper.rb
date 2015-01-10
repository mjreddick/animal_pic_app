module SessionsHelper

	# logs in the given user
	def log_in(user)
		session[:user_id] = user.id.to_s
	end

	# If the current user is logged in then it is returned
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end

	# Returns true if the user is logged in, false otherwise
	def logged_in?
		!current_user.nil?
	end

	def logged_in_as(id)
		id.to_s == session[:user_id]
	end

	def log_out
		session.delete(:user_id)
		@current_user = nil
	end

end
