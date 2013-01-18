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
      redirect_to :controller => 'my_studio', :action => 'index'
      return
    else
      @user = User.find(params[:user_id])
    end

    @comments = get_cheer_comments(@user.id, 3)
  end
end
