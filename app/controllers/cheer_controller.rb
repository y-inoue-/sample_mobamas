# -*- encoding : utf-8 -*-
class CheerController < ApplicationController

  #test時に値を変更したいこともあったのでグローバル変数化
  $cheer_interval_sec = Settings.cheer.cheer_interval_sec
  $cheer_limit_reset_sec = Settings.cheer.limit_reset_sec 
  
  # POST
  # 応援を行う
  # また条件が成立していたらptも増やす
  # \param  params[:target_id]：応援されたユーザーID
  def post_cheer
    user = current_user
    target = get_target
    if target == nil || user == target then
      redirect_to error_index_path
      return
    end
    @response = { target_id: target.id, target_name: target.name }

    result = exec_cheer(user, target)
    @response[:result] = result
    @response[:point]  = user.cheer_point
    
    respond_to do |format|
      format.html
      format.json { render json: @response }
    end
  end

  def exec_cheer(user, target)
    reset_limit(user)
    if user.cheer_count >= Settings.cheer.limit_count
      return  CHEER_RESULT[:fail_limit]
    end

    data = CheerUser.where(:user_id => user.id).where(:target_id => target.id).first
    if data == nil then
      data = CheerUser.new
      data.user_id = user.id
      data.target_id = target.id
      data.comment = false
      data.save
    elsif (Time.now - data.updated_at) < $cheer_interval_sec
      return  CHEER_RESULT[:fail_time]
    else
      data.touch # timestamp更新
    end
    result = add_point(user, true, Settings.cheer.add_cheer_point)
    add_point(target, false, Settings.cheer.add_cheer_point)
    return result
  end

  # 応援コメントを残す
  # また条件が成立していたらptも増やす
  # \param  params[:target_id]：応援されたユーザーID
  # \param  params[:comment]  ：コメントメッセージ
  def post_comment
    user = current_user
    target = get_target
    if target == nil || target == user then 
      redirect_to error_index_path
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
      redirect_to error_index_path
      return
    end

    is_add_point = !data.comment # 書き換わるので保存しておく
    if is_add_point then
      add_point(user, true, Settings.cheer.add_comment_point)
      add_point(target, false, Settings.cheer.add_comment_point)
      data.comment = true
      data.save
    end

    @response = { comment: params[:comment],
                  is_add_point: is_add_point,
                  point: user.cheer_point
    }

    respond_to do |format|
      format.html
      format.json { render json: @response }
    end
  end

  private
  # 特定時間経過による応援の回数上限とコメントによるpt増加フラグのリセットを行う
  # \param  user  ：リセット対象のユーザー
  def reset_limit(user)
    if user.cheer_updated_at == nil ||
        $cheer_limit_reset_sec == 0 ||
        (Time.now.to_i / $cheer_limit_reset_sec) > (user.cheer_updated_at.to_i / $cheer_limit_reset_sec)
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

    result = CHEER_RESULT[:success]
    if user.cheer_point < Settings.cheer.max_point then
      user.cheer_point += point
      if user.cheer_point > Settings.cheer.max_point then
        user.cheer_point = Settings.cheer.max_point
      end
    else
      result = CHEER_RESULT[:success_max]
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
      logger.debug("target_idがblank")
      return nil
    end

    begin
      target = User.find(params[:target_id])
    rescue ActiveRecord::RecordNotFound
      logger.debug("target_id=#{params[:target_id]}のユーザーは存在しません")
      target = nil
    end
    target
  end
end
