# -*- encoding : utf-8 -*-
require 'test_helper'

class UserSwitchControllerTest < ActionController::TestCase
  test "should post index user_id none" do
    post :index
    assert_redirected_to error_index_path
  end

  test "should post index" do
    post :index, user_id: User.first.id
    assert_response :success
  end


end
