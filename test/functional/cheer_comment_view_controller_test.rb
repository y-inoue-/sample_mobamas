require 'test_helper'

class CheerCommentViewControllerTest < ActionController::TestCase

  #各ユーザーに書き込まれたコメント数
  USER1_COMMENT_NUM = 3
  USER2_COMMENT_NUM = 2
  DEFAULT_COMMENT = "Hello!"

  setup do
    @user1 = users(:one)
    @user2 = users(:two)
    USER1_COMMENT_NUM.times do
      create_comment(@user2, @user1)
    end
    USER2_COMMENT_NUM.times do
      create_comment(@user1, @user2)
    end
  end

  def create_comment(user, target)
    comment = CheerComment.new
    comment.user_id = user.id
    comment.target_id = target.id
    comment.comment = DEFAULT_COMMENT
    comment.save
  end

  #
  # コメント表示に関するテスト
  #
  def get_comments(user, comment_num)
    get :index, user_id: user, format: :json
    assert_response :success
    is_myself = (user.id == get_current_user_id)
    result = JSON.parse(response.body)
    comment_info = result["comment_info"]
    assert_equal result["user_name"], user.name
    assert_equal comment_info["is_myself"], is_myself
    assert_equal comment_info["comment_array"].size, comment_num 
    
    comment_info["comment_array"].each do |c|
      assert_equal c["target_id"], user.id
      assert_equal c["comment"], DEFAULT_COMMENT
      if is_myself then
        assert_equal c["can_delete"], true
      end
    end
  end

  test "should get index" do
    set_current_user

    get_comments(@user1, USER1_COMMENT_NUM)
    get_comments(@user2, USER2_COMMENT_NUM)
  end

  test "should get index(param none)" do
    get :index
    assert_redirected_to error_index_path
  end

  test "should get index(illegal param)" do
    get :index, user_id: 0
    assert_redirected_to error_index_path
  end


  #
  # コメント削除に関するテスト
  #
  test "should delete delete_exec commend_id none" do
    assert_no_difference('CheerComment.count') do
      post :delete_exec
      assert_redirected_to error_index_path
    end
  end

  def check_delete_comment(comment_id)
    assert_difference('CheerComment.count', -1) do
      post :delete_exec, comment_id: comment_id
      assert_response :success
    end
  end

  test "should delete delete_exec write myself" do
    #コメントしたユーザーIDを書き換え
    comment = CheerComment.first
    comment.user_id = User.first.id
    comment.save

    check_delete_comment(comment.id)
 end
 
  test "should delete delete_exec written myself" do
    #コメントされたユーザーIDを書き換え
    comment = CheerComment.first
    comment.target_id = User.first.id
    comment.save

    check_delete_comment(comment.id)
  end
 

  test "should delete delete_exec other user comment" do
    #自分に関係ないコメントにするためにユーザーIDを書き換え
    comment = CheerComment.first
    comment.user_id = 0
    comment_target_id = 0
    comment.save

    assert_no_difference('CheerComment.count') do
      post :delete_exec, comment_id: comment.id
      assert_redirected_to error_index_path
    end
  end
  
  #削除コマンドを２回発行
  test "should delete delete_exec twice" do
    #コメントされたユーザーIDを書き換え
    comment = CheerComment.first
    comment.target_id = User.first.id
    comment.save

    check_delete_comment(comment.id)
    assert_no_difference('CheerComment.count') do
      post :delete_exec, comment_id: comment.id
      assert_redirected_to error_index_path
    end
  end
 
end
