# -*- encoding : utf-8 -*-
require 'test_helper'

class CheerControllerTest < ActionController::TestCase

  setup do
    set_current_user
  end

  def cheer(target = users(:two))
    post :post_cheer, target_id: target.id, format: :json
    assert_response :success
  end

  def check_cheer_result(result_code, check_point)
    result = JSON.parse(response.body)
    user1 = User.find(users(:one))
    user2 = User.find(users(:two))
    assert_equal result_code, result["result"]
    assert_equal result["point"], check_point
    assert_equal user1.cheer_point, check_point
    assert_equal user2.cheer_point, check_point
    assert_operator check_point, :<=, Settings.cheer.max_point
  end

  def clamp_point(point)
    if point > Settings.cheer.max_point then
      return Settings.cheer.max_point
    end
    point
  end

  #ポイント上限チェック
  test "should post index(point)" do
    count = Settings.cheer.max_point / Settings.cheer.add_cheer_point
    if (Settings.cheer.max_point % Settings.cheer.add_cheer_point) != 0 then
      count += 1
    end

    # maxまで応援する
    check_point = 0
    count.times do 
      cheer
      check_point = clamp_point( check_point + Settings.cheer.add_cheer_point )
      check_cheer_result(CHEER_RESULT[:success], check_point)
    end
    check_cheer_result(CHEER_RESULT[:success], Settings.cheer.max_point)

    # max状態から更に応援
    cheer
    check_cheer_result(CHEER_RESULT[:success_max], Settings.cheer.max_point)
  end

  #時間経過による応援失敗チェック
  test "should post index(time limit)" do
    $cheer_interval_sec = 1000
    check_point = Settings.cheer.add_cheer_point

    cheer
    check_cheer_result(CHEER_RESULT[:success], check_point)

    cheer
    check_cheer_result(CHEER_RESULT[:fail_time], check_point)


    # user switch
    set_current_user(users(:two))
    target = users(:one)
    check_point += Settings.cheer.add_cheer_point

    cheer(target)
    check_cheer_result(CHEER_RESULT[:success], check_point)
    cheer(target)
    check_cheer_result(CHEER_RESULT[:fail_time], check_point)
  end

  def check_success(result_code)
    unless result_code == CHEER_RESULT[:success] ||
            result_code == CHEER_RESULT[:success_max] then
      assert false
    end
  end

  def check_cheer_limit_cout(loop_count)
    loop_count.times do
      cheer
      result = JSON.parse(response.body)
      check_success(result["result"])
    end

    cheer
    result = JSON.parse(response.body)
    assert_equal result["result"], CHEER_RESULT[:fail_limit]
  end

  #応援回数上限チェック
  test "should post index(count limit)" do
    reset_sec = 24 * 3600
    $cheer_limit_reset_sec = reset_sec
    check_cheer_limit_cout(Settings.cheer.limit_count)
    
    #上限をresetしてもう１回チェック
    $cheer_limit_reset_sec = 0
    cheer
    result = JSON.parse(response.body)
    check_success(result["result"])
    
    $cheer_limit_reset_sec = reset_sec
    check_cheer_limit_cout(Settings.cheer.limit_count-1)
  end
 
  def post_comment(comment, target = users(:two))
   assert_difference('CheerComment.count') do
      post :post_comment, target_id: target.id, comment: comment, format: :json
      assert_response :success
    end
  end

  def check_comment_result(is_add_point, check_point, comment)
    result = JSON.parse(response.body)
    user1 = User.find(users(:one))
    user2 = User.find(users(:two))
    assert_equal result["is_add_point"], is_add_point
    assert_equal result["comment"], comment
    assert_equal result["point"], check_point
    assert_equal user1.cheer_point, check_point
    assert_equal user2.cheer_point, check_point
  end


  #ポイント上限チェック
  test "should post comment(point)" do
    # 連続コメントでリセットされないように
    reset_sec = 24 * 3600
    $cheer_limit_reset_sec = reset_sec
    
    # コメントを行う際に応援が実行されていることが前提になっている
    check_point = Settings.cheer.add_cheer_point
    cheer
    check_cheer_result(CHEER_RESULT[:success], check_point)

    comment = 'hello!'
    check_point = clamp_point( check_point + Settings.cheer.add_comment_point )
    post_comment(comment)
    check_comment_result(true, check_point, comment)

    # 連続コメントでポイントが増えないことを確認
    post_comment(comment)
    check_comment_result(false, check_point, comment)

    # limit_resetでポイントが増えることを確認
    $cheer_limit_reset_sec = 0
    check_point = clamp_point( check_point + Settings.cheer.add_comment_point )
    post_comment(comment)
    check_comment_result(true, check_point, comment)
    $cheer_limit_reset_sec = reset_sec
    post_comment(comment)
    check_comment_result(false, check_point, comment)
  end

  test "should post index(target_id none)" do
    post :post_cheer
    assert_redirected_to error_index_path
  end

  test "should post index(target_id myself)" do
    post :post_cheer, target_id: get_current_user_id
    assert_redirected_to error_index_path
  end

  test "should post index(illegal target_id)" do
    post :post_cheer, target_id: 0
    assert_redirected_to error_index_path
  end

  test "should post comment(param none)" do
    post :post_comment
    assert_redirected_to error_index_path
  end

  test "should post comment(target_id none)" do
    post :post_comment, comment: "hello!"
    assert_redirected_to error_index_path
  end

  test "should post comment(comment none)" do
    post :post_comment, target_id: users(:two).id
    assert_redirected_to error_index_path
  end

  test "should post comment(target_id myself)" do
    post :post_comment, target_id: get_current_user_id, comment: "hello!"
    assert_redirected_to error_index_path
  end

  test "should post comment(illegal target_id)" do
    post :post_comment, target_id: 0, comment: "hello!"
    assert_redirected_to error_index_path
  end

  test "should post comment(don't exec cheer)" do
    post :post_comment, target_id: users(:two), comment: "hello!"
    assert_redirected_to error_index_path
  end



end

