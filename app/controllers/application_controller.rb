# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  private
    def current_user
      if session[:user].blank? then
        session[:user] = 1
      end
      user = User.find(session[:user])
    end
end
