# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  private
    # 現在の操作ユーザーを取得する
    def current_user
      if session[:user].blank? then
        session[:user] = 1
      end
      user = User.find(session[:user])
    end

    # 指定したユーザーの応援コメントを取得する
    # \param  user_id   ：応援コメントを取得するユーザーID
    # \param  limit_num ：最大取得数
    def get_cheer_comments(user_id, limit_num)
      comment = CheerComment.where(target_id: user_id).order("updated_at DESC").limit(limit_num)
    end
end
