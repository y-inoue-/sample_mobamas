require 'test_helper'

class UserSwitchControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get post" do
    get :post
    assert_response :success
  end

end
