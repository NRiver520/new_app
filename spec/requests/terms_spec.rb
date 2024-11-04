require 'rails_helper'

RSpec.describe "Terms", type: :request do
  it "利用規約にアクセスできる" do
    get term_path
    expect(response).to have_http_status(:ok)
  end
end
