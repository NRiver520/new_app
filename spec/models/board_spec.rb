require 'rails_helper'

RSpec.describe Board, type: :model do
  it "有効なデータで掲示板作成が成功すること" do
    board = build(:board)
    expect(board).to be_valid
  end

  it "タイトル、本文が必須" do
    board = build(:board)
    board.title = nil
    board.body = nil
    board.valid?
    expect(board.errors[:title]).to include("を入力してください")
    expect(board.errors[:body]).to include("を入力してください")
  end
end
