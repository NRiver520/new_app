require 'rails_helper'

RSpec.describe "Manuals", type: :request do
  it "掲示板の使い方にアクセスできる" do
    get manual_path
    expect(response).to have_http_status(:ok)
  end
end
