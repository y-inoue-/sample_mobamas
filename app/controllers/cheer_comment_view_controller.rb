class CheerCommentViewController < ApplicationController
  
  # 指定されたユーザーの応援コメントを表示する
  # \param  params[:user_id]  ：指定ユーザーID
  def index
    begin
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      return
    end

    @myself = current_user
    @comments = get_cheer_comments(@user.id, 20)
  end

  def delete_success

  end
end
