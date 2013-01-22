# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  private
    # 現在の操作ユーザーを取得する
    def current_user
     if session[:user].blank? then
        session[:user] = User.first.id
      end
      user = User.find(session[:user])
    end

    # 指定したユーザーの応援コメントを取得する
    # \param  user_id   ：応援コメントを取得するユーザーID
    # \param  limit_num ：最大取得数
    def get_cheer_comment_info(user_id, limit_num)
      myself = current_user

      comments= CheerComment.where(target_id: user_id).order("updated_at DESC").limit(limit_num)
      comment_array = Array.new
      comments.each do |c|
        comment_array << { comment_id: c.id,
                            user_name: c.user.name,
                            user_id: c.user.id,
                            target_id: c.target.id,
                            comment: c.comment,
                            date: c.created_at.localtime,
                            can_delete: c.user.id == myself.id || c.target.id == myself.id
        }
      end
      comment_info = { is_myself: user_id == myself.id,
                        comment_array: comment_array
      }
    end
end
