# -*- encoding : utf-8 -*-
class MyStudioController < ApplicationController
  def index
    user = current_user
    comment_info = get_cheer_comment_info(user.id, 3)
    @response = { user_id: user.id,
                  user_name: user.name,
                  cheer_point: user.cheer_point,
                  comment_info: comment_info
    }

    respond_to do |format|
      format.html
      format.json { render json: @response }
    end
  end

end
