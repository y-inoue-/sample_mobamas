# -*- encoding : utf-8 -*-
class CheerController < ApplicationController

  #定数
  MAX_POINT = 100
  CHEER_POINT = 1
  COMMENT_POINT = 5
  
  LIMIT_COUNT = 10
  LIMIT_RESET_SEC     = 3 * 60
  CHEER_INTERVAL_SEC  = 3

  # 応援結果
  RESULT_SUCCESS     = 0  # 成功
  RESULT_SUCCESS_MAX = 1  # 成功したけど自分は既にpointMAX
  RESULT_FAIL_TIME   = 2  # 時間を開けていないので失敗
  RESULT_FAIL_LIMIT  = 3  # 応援上限により失敗

  
  def index
    user = current_user
    target = get_target
    if target == nil then
      return
    end
    @target = target

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
    if user.cheer_count >= LIMIT_COUNT
      return  RESULT_FAIL_LIMIT
    end

    reset_limit(user)

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
    result = add_point(user, true, CHEER_POINT)
    add_point(target, false, CHEER_POINT)
    return result
  end

  # 応援コメントを残す
  # また条件が成立していたらptも増やす
  # \param  params[:target_id]：応援されたユーザーID
  # \param  params[:comment]  ：コメントメッセージ
  def comment
    user = current_user
    target = get_target
    if target == nil then 
      return
    end

    # コメント保存
    com = CheerComment.new
    com.user_id = user.id
    com.target_id = target.id
    com.comment = params[:comment]
    com.save

    # pt付与
    reset_limit(user)

    data = CheerUser.where(:user_id => user.id).where(:target_id => target.id).first
    if data == nil then
      return
    end

    pt_msg = ""
    unless data.comment then
      add_point(user, true, COMMENT_POINT)
      add_point(target, false, COMMENT_POINT)
      data.comment = true
      data.save
      pt_msg = "友情ptが#{user.cheer_point}になりました"
    else
      pt_msg = "コメント済みのため友情ptは増えませんでした"
    end

    @msg = "#{params[:comment]}とコメントしました。\n"
    @msg += pt_msg
  end

  private
  # 特定時間経過による応援の回数上限とコメントによるpt増加フラグのリセットを行う
  # \param  user  ：リセット対象のユーザー
  def reset_limit(user)
    if user.cheer_updated_at == nil ||
        (Time.now.to_i / LIMIT_RESET_SEC) > (user.cheer_updated_at.to_i / LIMIT_RESET_SEC)
      then
      user.cheer_count = 0
      user.save

      datas = CheerUser.where(:user_id => user.id).where(:comment => true)
      datas.each do |d|
        d.comment = false
        d.save
      end
    end
  end

  # 友情ptを付与する
  # \param  user      ：対象ユーザー
  # \param  is_myself ：対象ユーザーが自分か
  # \param  point     ：付与するpt
  def add_point(user, is_myself, point)
    if is_myself then
      user.cheer_count += 1
      user.cheer_updated_at = Time.now
    end

    result = RESULT_SUCCESS
    if user.cheer_point < MAX_POINT then
      user.cheer_point += point
      if user.cheer_point > MAX_POINT then
        user.cheer_point = MAX_POINT
      end
    else
      result = RESULT_SUCCESS_MAX
    end

    user.save
    return  result
  end

  # ターゲットのユーザーを取得する
  # \param  params[:target_id]  ：ターゲットユーザーのID
  def get_target
    target = nil
    @msg = ''
    if params[:target_id].blank? then
      @msg = 'target_idを指定してアクセスしてください'
      return nil
    end

    begin
      target = User.find(params[:target_id])
    rescue ActiveRecord::RecordNotFound
      @msg = "target_id=#{params[:target_id]}のユーザーは存在しません"
      target = nil
    end
    target
  end
end
