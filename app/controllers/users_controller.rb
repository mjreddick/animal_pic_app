class UsersController < ApplicationController
	before_action :require_correct_user, only: [:edit, :update, :destroy]

	def show
		@user = viewed_user
		@type = params[:type] || "friends"
		# pics = Picture.where(user_id: @user.id, is_active: true).desc(:created_at)
		pics = @user.pictures.where(is_active: true).desc(:created_at)
		friend_pics = pics.where(is_friend: true)
		fiend_pics = pics.where(is_friend: false)
		fav_pics = Picture.in(id: @user.favorites).where(is_active: true)

		if @type == "friends"
			@pictures = friend_pics
		elsif @type == "fiends"
			@pictures = fiend_pics
		else
			@pictures = fav_pics
		end
		results = []
		@pictures.each do |pic|
			results << pic.id.to_s
		end
		cookies[:results] = JSON.generate(results)
		
		@friend_total = 0
		@vote_total = 0
		@num_pics = pics.length
		pics.each do |pic|
			@friend_total += pic.friended_by.length
			@vote_total += pic.total_votes
		end
		if @vote_total == 0
			@friend_percentage = 50
		else
			@friend_percentage = ((@friend_total.to_f / @vote_total.to_f) * 100).floor
		end

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
		if viewed_user.update_attributes(user_edit_params)
			redirect_to user_path
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
			params.require(:user).permit(:username, :pet_name, :email, :password, :password_confirmation, :image, :about)
		end

		def user_edit_params
			params.require(:user).permit(:pet_name, :email, :about)
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
