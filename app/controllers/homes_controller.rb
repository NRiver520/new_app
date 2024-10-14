class HomesController < ApplicationController
  skip_before_action :require_login, only: %i[top]
  def top
    @recent_boards = Board.order(created_at: :desc).limit(4)
    @pickup_boards = Board.order("RAND()").limit(4)
    @popular_boards = Board.left_joins(:comments).group(:id).order("count(comments.id) desc").limit(4)
  end
end
