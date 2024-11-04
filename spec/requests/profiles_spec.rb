require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }
  before do
    login_user(user, '12345678', login_path)
  end
  describe "get /profile" do
    context "ログインしていると" do
      it "ユーザーページにアクセスできる" do
        get profile_path
        expect(response).to have_http_status(:ok)
      end
    end
    context "ログインしていないと" do
      it "ログインページに遷移する" do
        delete logout_path
        get profile_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_path)
      end
    end
  end
  describe "get /profile/edit" do
    context "ログインしていると" do
      it "ユーザー編集ページにアクセスできる" do
        get edit_profile_path
        expect(response).to have_http_status(:ok)
      end
    end
    context "ログインしていないと" do
      it "ログインページに遷移する" do
        delete logout_path
        get edit_profile_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
