class BoardsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_board, only: %i[edit update destroy]

  def index
    @q = Board.ransack(params[:q])
    @boards = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      flash[:success] = "掲示板を作成しました"
      redirect_to boards_path
    else
      flash[:danger] = "掲示板の作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @board = Board.find(params[:id])
    @title = @board.title
    @comment = Comment.new
    @comments = @board.comments.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def edit
  end

  def update
    if @board.update(board_params)
      flash[:success] = "編集しました"
      redirect_to @board
    else
      flash[:danger] = "編集に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board.destroy!
    flash[:success] = "削除しました"
    redirect_to boards_path status: :see_other
  end

  private

  def set_board
    @board = current_user.boards.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "権限がありません"
    redirect_to boards_path
  end

  def board_params
    params.require(:board).permit(:title, :body)
  end
end
