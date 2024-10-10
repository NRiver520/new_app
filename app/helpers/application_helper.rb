module ApplicationHelper
  def page_title(title = "")
    base_title = "ベイブレード交流掲示板"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def rank_border_class(rank)
    case rank
    when "ノーランク"
      "border-light"
    when "ブロンズ"
      "border-primary"
    when "シルバー"
      "border-success"
    when "ゴールド"
      "border-danger"
    when "プラチナ"
      "border-warning"
    end
  end
end
