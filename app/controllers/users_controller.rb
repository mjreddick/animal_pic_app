class UsersController < ApplicationController
	before_action :require_correct_user, only: [:edit, :update, :destroy]

	def show
		@user = viewed_user
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			log_in @user
			redirect_to user_path(@user)
		else
			render :new
		end
	end

	def edit
		@user = viewed_user		
	end

	def update
		if viewed_user.update_attributes(user_params)
			redirect_to users_path
		else
			render :edit
		end
	end

	def destroy
		#set all pictures for this users account to not be active
		viewed_user.pictures.each do |pic|
			pic.is_active = false
			pic.save
		end
		#set this user to not be active
		viewed_user.is_active = false
		viewed_user.save
		#log the user out
		log_out
		redirect_to :root
	end

	private

		def user_params
			params.require(:user).permit(:username, :pet_name, :email, :password, :password_confirmation)
		end

		def viewed_user
			@user ||= User.where(id: params[:id], is_active: true).first
		end

		def require_correct_user
			unless logged_in_as(params[:id])
				flash[:error] = "You must be logged in to complete that action"
				redirect_to :login and return
			end
		end

end
