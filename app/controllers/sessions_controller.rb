class SessionsController < ApplicationController
  def new
  end

	def create
  	user = User.where(username: params[:session][:username].downcase, is_active: true).first
  	if user && user.authenticate(params[:session][:password])
 			log_in user
 			redirect_to :root
   	else
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	log_out
  	redirect_to root_url
  end
end
