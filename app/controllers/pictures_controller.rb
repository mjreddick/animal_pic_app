class PicturesController < ApplicationController
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
		@picture = Picture.find(params[:id])
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
		@picture = Picture.find(params[:id])		
	end

	def update
		@picture = Picture.find(params[:id])
		if @picture.update_attributes(picture_params)
			redirect_to pictures_path
		else
			render :edit
		end
	end

	def destroy
		@picture = Picture.find(params[:id])
		@picture.destroy
		redirect_to pictures_path
	end

	private

	def picture_params
		params.require(:picture).permit(:title, :caption, :category, :image)
	end
end
