# -*- encoding : utf-8 -*-
class UserSwitchController < ApplicationController

  # 操作するユーザーを切り替える
  # \param  params[:user_id]  ：切り替え対象のユーザーID
  def index
    begin 
      user_index = params[:user_id]
      @user = User.find(user_index)
    rescue ActiveRecord::RecordNotFound
      user_index = User.first.id 
      @user = User.find(user_index)
    end
    session[:user] = user_index
  end

end
