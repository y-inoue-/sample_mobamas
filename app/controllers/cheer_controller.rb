# -*- encoding : utf-8 -*-
class CheerController < ApplicationController

  #定数
  MAX_POINT = 10
  ADD_POINT = 1

  # 応援結果
  RESULT_SUCCESS     = 0  # 成功
  RESULT_SUCCESS_MAX = 1  # 成功したけど自分は既にpointMAX
  RESULT_FAIL_TIME   = 2  # 時間を開けていないので失敗
  RESULT_FAIL_LIMIT  = 3  # 応援上限により失敗

  CHEER_INTERVAL_SEC  = 10
  
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

    @msg = "#{user.name}が#{target.name}を応援しました。\n#{result_msg}"
  end

  def cheer(user, target)
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
      p data.updated_at
      data.touch # timestamp更新
    end
    result = add_point(user)
    add_point(target)
    return result
  end

  def add_point(user)
    if user.cheer_point < MAX_POINT then
      user.cheer_point += ADD_POINT
      if user.cheer_point > MAX_POINT then
        user.cheer_point = MAX_POINT
      end
      user.save
      return RESULT_SUCCESS
    end
    return  RESULT_SUCCESS_MAX
  end
end
