class BoardsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @boards = Board.includes(:user).order(created_at: :desc)
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      flash[:success] = '掲示板を作成しました'
      redirect_to boards_path
    else
      flash[:danger] = '掲示板の作成に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @board = Board.find(params[:id])
    @title = @board.title
  end

  private 

  def board_params
    params.require(:board).permit(:title, :body)
  end
end
