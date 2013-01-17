# -*- encoding : utf-8 -*-
class UserSwitchController < ApplicationController
  def index
    #@user_list = User.all.map{|i| [i.name, i.id]}
    
    #ユーザーの切り替えはURLの引数で行う
    begin 
      user_index = params[:id]
      @user = User.find(user_index)
    rescue ActiveRecord::RecordNotFound
      user_index = 1
      @user = User.find(user_index)
    end
    session[:user] = user_index
  end

end
