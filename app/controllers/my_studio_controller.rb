# -*- encoding : utf-8 -*-
class MyStudioController < ApplicationController
  def index
    @user = current_user
  end

end
