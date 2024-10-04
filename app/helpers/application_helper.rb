module ApplicationHelper
  def rank_border_class(rank)
    case rank
    when 'ノーランク'
      'border-light'
    when 'ブロンズ'
      'border-primary'
    when 'シルバー'
      'border-success'
    when 'ゴールド'
      'border-danger'
    when 'プラチナ'
      'border-warning'
    end
  end
end
