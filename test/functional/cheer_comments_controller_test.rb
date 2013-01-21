require 'test_helper'

class CheerCommentsControllerTest < ActionController::TestCase
  setup do
    @cheer_comment = cheer_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cheer_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cheer_comment" do
    assert_difference('CheerComment.count') do
      post :create, cheer_comment: { comment: @cheer_comment.comment, disp: @cheer_comment.disp, target_id: @cheer_comment.target_id, user_id: @cheer_comment.user_id }
    end

    assert_redirected_to cheer_comment_path(assigns(:cheer_comment))
  end

  test "should show cheer_comment" do
    get :show, id: @cheer_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cheer_comment
    assert_response :success
  end

  test "should update cheer_comment" do
    put :update, id: @cheer_comment, cheer_comment: { comment: @cheer_comment.comment, disp: @cheer_comment.disp, target_id: @cheer_comment.target_id, user_id: @cheer_comment.user_id }
    assert_redirected_to cheer_comment_path(assigns(:cheer_comment))
  end

  test "should destroy cheer_comment" do
    assert_difference('CheerComment.count', -1) do
      delete :destroy, id: @cheer_comment
    end

    assert_redirected_to cheer_comments_path
  end
end
