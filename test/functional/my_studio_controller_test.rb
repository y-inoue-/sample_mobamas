# -*- encoding : utf-8 -*-
require 'test_helper'

class MyStudioControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get cheer" do
    get :cheer
    assert_response :success
  end

end
