require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "有効なデータでコメントの作成が成功すること" do
    comment = build(:comment)
    expect(comment).to be_valid
  end
end
