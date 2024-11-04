require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  it "ログインページにアクセスできる" do
    get login_path
    expect(response).to have_http_status(:ok)
  end
end
