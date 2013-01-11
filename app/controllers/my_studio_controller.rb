# -*- encoding : utf-8 -*-
class MyStudioController < ApplicationController
  def index
    get_user
  end

  def cheer
    user = get_user
    @cheer_msg = ""
    if user.cheer_point < 10 then
      user.cheer_point += 1
      user.save
      @cheer_msg = "応援しました。友情pt:#{user.cheer_point}"
    else
      @cheer_msg = "これ以上は友情ptを増やせません"
    end
  end

  def get_user
    @user = User.find(1)
  end
end
