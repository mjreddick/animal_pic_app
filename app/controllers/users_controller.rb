class UsersController < ApplicationController
	before_action :require_correct_user, only: [:edit, :update, :destroy]

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
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
		viewed_user		
	end

	def update
		if viewed_user.update_attributes(user_params)
			redirect_to users_path
		else
			render :edit
		end
	end

	def destroy
		viewed_user.destroy
		redirect_to users_path
	end

	private

		def user_params
			params.require(:user).permit(:username, :pet_name, :email, :password, :password_confirmation)
		end

		def viewed_user
			@user = User.find(params[:id])
		end

		def require_correct_user
			unless logged_in_as(params[:id])
				flash[:error] = "You must be logged in to complete that action"
				redirect_to :login and return
			end
		end

end
