# -*- encoding : utf-8 -*-
class UserPageController < ApplicationController

  # 指定されたユーザーのページを表示する
  # ユーザーIDが指定されていなかったり、自分自身だった場合はマイスタジオに飛ばす
  # \param  params[:user_id]  ：ユーザーID
  def index
    if params[:user_id].blank? ||
        session[:user].blank? ||
        session[:user].to_s == params[:user_id]
        then
      redirect_to my_studio_index_path
      return
    else
      begin
        user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to error_index_path
        return
      end
    end

    comment_info = get_cheer_comment_info(user.id, 3)
    @response = { user_id: user.id,
                  user_name: user.name,
                  comment_info: comment_info
    }

    respond_to do |format|
      format.html
      format.json { render json: @response }
    end
  end
end
