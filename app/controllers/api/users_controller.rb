module API
  class UsersController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json

    def add_favorite
      # require user is logged in
      if logged_in?
        # find the picture
        picture = Picture.where(id: params[:picture_id], is_active: true).first

        if picture
          current_user.add_favorite(picture)
        else
          # picture with the given id doesn't exist
          return head 422
        end

      else
        # user not authorized
        return head 401
      end
      current_user.save

      return head 204
    end # add_favorite

    def remove_favorite
      # require user is logged in
      if logged_in?
        # find the picture
        picture = Picture.where(id: params[:picture_id], is_active: true).first

        if picture
          current_user.remove_favorite(picture)
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
    end # remove_favorite

  end
end 