require 'test_helper'

class CheerUsersControllerTest < ActionController::TestCase
  setup do
    @cheer_user = cheer_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cheer_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cheer_user" do
    assert_difference('CheerUser.count') do
      post :create, cheer_user: { comment: @cheer_user.comment, target_id: @cheer_user.target_id, user_id: @cheer_user.user_id }
    end

    assert_redirected_to cheer_user_path(assigns(:cheer_user))
  end

  test "should show cheer_user" do
    get :show, id: @cheer_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cheer_user
    assert_response :success
  end

  test "should update cheer_user" do
    put :update, id: @cheer_user, cheer_user: { comment: @cheer_user.comment, target_id: @cheer_user.target_id, user_id: @cheer_user.user_id }
    assert_redirected_to cheer_user_path(assigns(:cheer_user))
  end

  test "should destroy cheer_user" do
    assert_difference('CheerUser.count', -1) do
      delete :destroy, id: @cheer_user
    end

    assert_redirected_to cheer_users_path
  end
end
