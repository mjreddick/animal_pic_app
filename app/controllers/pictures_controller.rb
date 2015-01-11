class PicturesController < ApplicationController
	before_action :require_correct_user, only: [:edit, :update, :destroy]

	def index
		#Find the correct type of pictures
		@pictures = Picture.where(is_active: true)
		case params[:type]
		when "all"
		when "friends"
			@pictures = @pictures.where(is_friend: true)
		when "fiends"
			@pictures = @pictures.where(is_friend: false)
		else
			redirect_to :root and return
		end

		#Sort those pictures
		case params[:sort]
		when "newest"
			@pictures = @pictures.desc(:created_at)
		when "top"
			@pictures = @pictures.desc(:total_votes)
		else 
			redirect_to :root and return
		end

		#Only look at the first several results
		@pictures = @pictures.limit(20)
	end

	def show
		current_picture
	end

	def new
		if logged_in?
			@picture = Picture.new
			render :new
		else
			redirect_to new_session_path
		end
	end

	def create
		if logged_in?
			@picture = current_user.pictures.new(picture_params)			
			if @picture.save
				redirect_to pictures_path
			else
				render :new
			end
		else
			flash[:error] = "Must be logged in to post"
			redirect_to new_session_path
		end
	end

	def edit
		current_picture		
	end

	def update
		if current_picture.update_attributes(picture_params)
			redirect_to pictures_path
		else
			render :edit
		end
	end

	def destroy
		current_picture.destroy
		redirect_to pictures_path
	end

	def vote
		case params[:vote_type]
		when "friend"
			current_picture.vote_friend(current_user)
		when "fiend"
			current_picture.vote_fiend(current_user)
		else
			render :show and return
		end
		current_picture.save
		render :show and return
	end

	private

		def current_picture
			@picture ||= Picture.find(params[:id])
		end

		def picture_params
			params.require(:picture).permit(:title, :caption, :category, :image)
		end

		def require_correct_user
			unless logged_in_as(current_picture.user.id)
				flash[:error] = "You must be logged in to complete that action"
				redirect_to :login and return
			end
		end
end
