# -*- encoding : utf-8 -*-
class UserSwitchController < ApplicationController

  # 操作するユーザーを切り替える
  # \param  params[:user_id]  ：切り替え対象のユーザーID
  def index
    @response = Hash.new
    begin 
      user_index = params[:user_id]
      user = User.find(user_index)
      @response['name'] = user.name
      session[:user] = user_index
    rescue ActiveRecord::RecordNotFound
      redirect_to error_index_path
      return
    end

    respond_to do |format|
      format.html
      format.json { render json: @response }
    end
  end

end
