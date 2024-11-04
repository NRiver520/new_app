require 'rails_helper'

RSpec.describe User, type: :model do
  it "有効なデータでユーザー登録が成功すること" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "ユーザー名がユニークであること" do
    user1 = create(:user)
    user2 = build(:user)
    user2.username = user1.username
    user2.valid?
    expect(user2.errors[:username]).to include("はすでに使用されています")
  end

  it "メールアドレスがユニークであること" do
    user1 = create(:user)
    user2 = build(:user)
    user2.email = user1.email
    user2.valid?
    expect(user2.errors[:email]).to include("はすでに使用されています")
  end

  it "ユーザー名、メールアドレスが必須" do
    user = build(:user)
    user.username = nil
    user.email = nil
    user.valid?
    expect(user.errors[:username]).to include("を入力してください")
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "パスワードが3文字以上でないと無効であること" do
    user = build(:user, password: "12", password_confirmation: "12")
    user.valid?
    expect(user.errors[:password]).to include("は3文字以上で入力してください")
  end

  it "パスワード確認が必須であること" do
    user = build(:user, password: "123", password_confirmation: nil)
    user.valid?
    expect(user.errors[:password_confirmation]).to include("を入力してください")
  end

  it "パスワードとpassword_confirmationが一致していること" do
    user = build(:user, password: "123456", password_confirmation: "654321")
    user.valid?
    expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
  end
end
