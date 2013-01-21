# -*- encoding : utf-8 -*-
require 'test_helper'

class UserPageControllerTest < ActionController::TestCase
  setup do
    @request.session = ActionController::TestSession.new
  end

  test "should get index" do
    @request.session[:user] = User.first
    get :index, user_id: users(:one).id
    assert_response :success
  end

end
