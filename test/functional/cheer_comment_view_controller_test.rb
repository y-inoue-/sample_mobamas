require 'test_helper'

class CheerCommentViewControllerTest < ActionController::TestCase
  test "should get delete_success" do
    get :delete_success
    assert_response :success
  end

end
