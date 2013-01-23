require 'test_helper'

class CheerCommentViewControllerTest < ActionController::TestCase

  test "should post delete_exec commend_id none" do
    post :delete_exec
    assert_redirected_to error_index_path
  end

  test "should post delete_exec write myself" do
    #コメントしたユーザーIDを書き換え
    comment = CheerComment.first
    comment.user_id = User.first.id
    comment.save

    post :delete_exec, comment_id: comment.id
    assert_response :success
  end
 
  test "should post delete_exec written myself" do
    #コメントされたユーザーIDを書き換え
    comment = CheerComment.first
    comment.target_id = User.first.id
    comment.save

    post :delete_exec, comment_id: comment.id
    assert_response :success
  end
 

  test "should post delete_exec other user comment" do
    #自分に関係ないコメントにするためにユーザーIDを書き換え
    comment = CheerComment.first
    comment.user_id = 0
    comment_target_id = 0
    comment.save

    post :delete_exec, comment_id: comment.id
    assert_redirected_to error_index_path
  end
 
end
