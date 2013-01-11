class MyStudioController < ApplicationController
  def index
    user = User.find(1)
    @name = user.name
    @cheer_point = user.cheer_point
  end
end
