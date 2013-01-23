require 'test_helper'

class CheerCommentViewControllerTest < ActionController::TestCase
  test "should post delete_exec commend_id none" do
    post :delete_exec
    assert_redirected_to error_index_path
  end

  test "should post delete_exec" do
    post :delete_exec, comment_id: CheerComment.first.id
    assert_redirected_to cheer_comment_view_delete_success_path
  end

  test "should get delete_success" do
    get :delete_success
    assert_response :success
  end

end
