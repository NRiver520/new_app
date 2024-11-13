class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :danger
  before_action :set_sidebar_boards

  private

  def set_sidebar_boards
    @recent_boards = Board.order(created_at: :desc).limit(4)
    @pickup_boards = Board.order("RAND()").limit(4)
    @popular_boards = Board.left_joins(:comments).group(:id).order("count(comments.id) desc").limit(4)
  end

  def not_authenticated
    flash[:danger] = "ログインしてください"
    redirect_to login_path
  end
end
