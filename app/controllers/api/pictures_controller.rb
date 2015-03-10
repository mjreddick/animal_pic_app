module API
  class PicturesController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json

    def vote 
      # require user is logged in to vote
      if logged_in?
        # find the picture
        picture = Picture.where(id: params[:id], is_active: true).first

        if picture
          if params[:vote_type]
            case params[:vote_type]
            when "friend"
              picture.vote_friend(current_user)
            when "fiend"
              picture.vote_fiend(current_user)
            else
              # not an allowed vote_type
              return head 422
            end
          else
            # no vote_type specified
            return head 400
          end
        else
          # picture with the given id doesn't exist
          return head 422
        end

      else
        # user not authorized
        return head 401
      end
      picture.save

      return head 204
      
    end

  end
end