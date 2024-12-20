class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      flash[:success] = "返信しました"
      redirect_to board_path(comment.board)
    else
      flash[:danger] = "本文を入力してください"
      redirect_to board_path(comment.board)
    end
  end

  def destroy
    @comment.destroy!
    flash[:success] = "削除しました"
    redirect_to board_path(@comment.board), status: :see_other
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "権限がありません"
    redirect_to board_path
  end

  def comment_params
    params.require(:comment).permit(:body, :comment_image, :comment_image_cache).merge(board_id: params[:board_id])
  end
end
