# -*- encoding : utf-8 -*-
class MyStudioController < ApplicationController
  def index
    @user = current_user
    @comments = get_cheer_comments(@user.id, 3)
  end

end
