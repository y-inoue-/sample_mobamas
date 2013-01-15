# -*- encoding : utf-8 -*-
class MyStudioController < ApplicationController
  def index
    @user = current_user
  end

  def cheer
    user = current_user
    @cheer_msg = ""
    if user.cheer_point < 10 then
      user.cheer_point += 1
      user.save
      @cheer_msg = "応援しました。友情pt:#{user.cheer_point}"
    else
      @cheer_msg = "これ以上は友情ptを増やせません"
    end
  end

end
