require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  let(:user) { create(:user) }
  before do
    login_user(user, '12345678', login_path)
  end
  describe "GET /contact" do
    context "ログインしている場合" do
      it "お問い合わせにアクセスできる" do
        get new_contact_path
        expect(response).to have_http_status(:ok)
      end
    end
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        delete logout_path
        get new_contact_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
