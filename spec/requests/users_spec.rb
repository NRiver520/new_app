require 'rails_helper'

RSpec.describe "Users", type: :request do
  it "会員登録にアクセスできる" do
    get new_user_path
    expect(response).to have_http_status(:ok)
  end
end
