require 'rails_helper'

RSpec.describe "Privacies", type: :request do
  it "プライバシーポリシーにアクセスできる" do
    get privacy_path
    expect(response).to have_http_status(:ok)
  end
end
