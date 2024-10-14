require 'rails_helper'

RSpec.describe "Terms", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/terms/index"
      expect(response).to have_http_status(:success)
    end
  end

end
