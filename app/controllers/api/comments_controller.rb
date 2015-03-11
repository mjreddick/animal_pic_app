module API
  class CommentsController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json

    def create
      # require user is logged in
      if logged_in?
        # find the picture
        picture = Picture.where(id: params[:picture_id], is_active: true).first

        if picture
          comment = picture.comments.new(comment_text: params[:text], user: current_user)
        else
          # picture with the given id doesn't exist
          return head 422
        end

      else
        # user not authorized
        return head 401
      end
      comment.save

      return head 204
    end # create

  end
end