# -*- encoding : utf-8 -*-
require 'test_helper'

class UserPageControllerTest < ActionController::TestCase
  setup do
    @request.session = ActionController::TestSession.new
    @request.session[:user] = users(:one).id
  end

  test "should get index" do
    get :index, user_id: users(:two).id
    assert_response :success
  end


  test "should get index user_id none" do
    get :index
    assert_redirected_to my_studio_index_path
  end

  test "should get index user_id = myself" do
    get :index, user_id: users(:one).id
    assert_redirected_to my_studio_index_path
  end

  test "should get index user_id illegal" do
    get :index, user_id: users(:two).id + 1
    assert_redirected_to error_index_path
  end


end
