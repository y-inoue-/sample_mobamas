require 'test_helper'

class CheerCommentViewControllerTest < ActionController::TestCase
  test "should get delete_exec" do
    get :delete_exec
    assert_response :success
  end

 test "should get delete_success" do
    get :delete_success
    assert_response :success
  end

end
