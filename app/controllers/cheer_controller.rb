# -*- encoding : utf-8 -*-
class CheerController < ApplicationController

  #定数
  MAX_POINT = 100
  ADD_POINT = 1
  
  LIMIT_COUNT = 10
  LIMIT_RESET_SEC     = 3 * 60
  CHEER_INTERVAL_SEC  = 3

  # 応援結果
  RESULT_SUCCESS     = 0  # 成功
  RESULT_SUCCESS_MAX = 1  # 成功したけど自分は既にpointMAX
  RESULT_FAIL_TIME   = 2  # 時間を開けていないので失敗
  RESULT_FAIL_LIMIT  = 3  # 応援上限により失敗

  
  def index
    @msg = ''
    if params[:target_id].blank? then
      @msg = 'target_idを指定してアクセスしてください'
      return
    end

    begin
      target = User.find(params[:target_id])
    rescue ActiveRecord::RecordNotFound
      @msg = "target_id=#{params[:target_id]}のユーザーは存在しません"
      return
    end

    user = current_user
    result = cheer(user, target)
    result_msg = ""
    case result
    when RESULT_SUCCESS
      result_msg = "ptが#{user.cheer_point}になりました"
    when RESULT_SUCCESS_MAX
      result_msg = "応援しましたがこれ以上ptを増やすことはできません"
    when RESULT_FAIL_TIME
      result_msg = "前回の応援から時間が経っていません"
    when RESULT_FAIL_LIMIT
      result_msg = "応援の上限に達しました"
    end

    @msg = "#{user.name}が#{target.name}を応援しました。\n"
    @msg += "#{result_msg}\n"
    @msg += "count=#{user.cheer_count}"
  end

  def cheer(user, target)
    # 応援上限のリセット
    if user.cheer_updated_at == nil ||
        (Time.now.to_i / LIMIT_RESET_SEC) > (user.cheer_updated_at.to_i / LIMIT_RESET_SEC)
      then
      user.cheer_count = 0
      user.save
    end
    if user.cheer_count >= LIMIT_COUNT
      return  RESULT_FAIL_LIMIT
    end

    data = CheerUser.where(:user_id => user.id).where(:target_id => target.id).first
    if data == nil then
      data = CheerUser.new
      data.user_id = user.id
      data.target_id = target.id
      data.comment = false
      data.save
    elsif (Time.now - data.updated_at) < CHEER_INTERVAL_SEC
      return  RESULT_FAIL_TIME
    else
      data.touch # timestamp更新
    end
    result = add_point(user, true)
    add_point(target, false)
    return result
  end

  def add_point(user, is_user)
    if is_user then
      user.cheer_count += 1
      user.cheer_updated_at = Time.now
    end

    result = RESULT_SUCCESS
    if user.cheer_point < MAX_POINT then
      user.cheer_point += ADD_POINT
      if user.cheer_point > MAX_POINT then
        user.cheer_point = MAX_POINT
      end
    else
      result = RESULT_SUCCESS_MAX
    end

    user.save
    return  result
  end
end
