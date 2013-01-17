# -*- encoding : utf-8 -*-
class UserPageController < ApplicationController
  def index
    if params[:id].blank? ||
        session[:user].blank? ||
        session[:user].to_s == params[:id]
        then
      redirect_to :controller => 'my_studio', :action => 'index'
      return
    else
      @user = User.find(params[:id])
    end
  end
end
