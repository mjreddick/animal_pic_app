class PicturesController < ApplicationController
	before_action :require_correct_user, only: [:edit, :update, :destroy]

	def index

		@pictures = get_pictures(20)

		results = []
		@pictures.each do |pic|
			results << pic.id.to_s
		end
		cookies[:results] = JSON.generate(results)
	end

	def show
		@picture = current_picture
		results = JSON.parse(cookies[:results]) || []
		index = params[:index].to_i || 0
		
		if index >= results.length - 1
			@pictures = get_pictures(20)
			@pictures = @pictures.not_in(id: results)

			@pictures.each do |pic|
				results << pic.id.to_s
			end

			cookies[:results] = JSON.generate(results)
		end
		@prev_index = index == 0 ? 0 : index - 1
		@next_index = index >= results.length - 1 ? index : index + 1
		@prev_picture = Picture.find(results[@prev_index])
		@next_picture = Picture.find(results[@next_index])


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
				redirect_to :root
			else
				render :new
			end
		else
			flash[:error] = "Must be logged in to post"
			redirect_to new_session_path
		end
	end

	def edit
		@picture = current_picture		
	end

	def update
		if current_picture.update_attributes(picture_params)
			redirect_to :root
		else
			render :edit
		end
	end

	def destroy
		current_picture.is_active = false
		current_picture.save
		redirect_to :root
	end

	def vote
		case params[:vote_type]
		when "friend"
			current_picture.vote_friend(current_user)
		when "fiend"
			current_picture.vote_fiend(current_user)
		else
			redirect_to picture_path(current_picture, {type: params[:type], sort: params[:sort], index: params[:index]}) and return
		end
		current_picture.save
		redirect_to picture_path(current_picture, {type: params[:type], sort: params[:sort], index: params[:index]}) and return
	end

	private

		def current_picture
			@picture ||= Picture.where(id: params[:id], is_active: true).first
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

		def get_pictures(num_pics)
			#Find the correct type of pictures
			pictures = Picture.where(is_active: true)
			case params[:type]
			when "all"
			when "friends"
				pictures = pictures.where(is_friend: true)
			when "fiends"
				pictures = pictures.where(is_friend: false)
			else
				redirect_to :root and return
			end

			#Sort those pictures
			case params[:sort]
			when "newest"
				pictures = pictures.desc(:created_at, :id)
			when "top"
				pictures = pictures.desc(:total_votes, :id)
			else 
				redirect_to :root and return
			end

			#Only look at the first several results
			pictures = pictures.limit(num_pics) || []
			
		end
end
