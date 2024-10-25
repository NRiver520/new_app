class BoardsController < ApplicationController
  skip_before_action :require_login, only: %i[index show autocomplete]
  before_action :set_board, only: %i[edit update destroy enter_password verify_password]

  def index
    @q = Board.ransack(params[:q])
    @boards = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.build(board_params)
    Rails.logger.debug "Board Params: #{board_params.inspect}"
    if @board.save
      session[:authenticated_board_id] = @board.id
      flash[:success] = "掲示板を作成しました"
      redirect_to @board
    else
      Rails.logger.debug "Board save failed: #{@board.errors.full_messages.join(", ")}"
      flash[:danger] = "掲示板の作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @board = Board.find(params[:id])
    if @board.password_digest.present? && session[:authenticated_board_id] != @board.id
      redirect_to enter_password_board_path(@board)
    else
      @title = @board.title
      @comment = Comment.new
      @comments = @board.comments.includes(:user).order(created_at: :desc).page(params[:page])
    end
  end

  def edit
  end

  def update
    if @board.update(board_params)
      session[:authenticated_board_id] = @board.id
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
    redirect_to boards_path, status: :see_other
  end

  def enter_password
    if @board.password_digest.present?
      render :enter_password
    else
      redirect_to @board
    end
  end

  def autocomplete
    boards = Board.where('title LIKE ?', "%#{params[:term]}%").limit(10).pluck(:title)
    render json: boards
  end

  def verify_password
    if @board.authenticate(params[:password])
      session[:authenticated_board_id] = @board.id
      redirect_to @board
    else
      flash[:danger] = "パスワードが違います"
      redirect_to enter_password_board_path(@board)
    end
  end

  private

  def set_board
    @board = current_user.boards.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "権限がありません"
    redirect_to boards_path
  end

  def board_params
    params.require(:board).permit(:title, :body, :password).tap do |board_params|
      board_params[:password] = nil if board_params[:password].blank?
    end
  end
end
