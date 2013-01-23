class CheerCommentViewController < ApplicationController
  
  # 指定されたユーザーの応援コメントを表示する
  # \param  params[:user_id]  ：指定ユーザーID
  def index
    begin
      user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to error_index_path
      return
    end

    @response = { user_name: user.name,
                  comment_info: get_cheer_comment_info(user.id, 20)
    }
    
    respond_to do |format|
      format.html
      format.json { render json: @response }
    end
  end

  # コメントの削除を実行
  # \param  params[:comment_id] ：削除するコメントID
  def delete_exec
    begin 
      CheerComment.destroy(params[:comment_id])
    rescue
      redirect_to error_index_path
      return
    end

    redirect_to cheer_comment_view_delete_success_path
  end

  # コメントの削除に成功
  def delete_success
  end
end
