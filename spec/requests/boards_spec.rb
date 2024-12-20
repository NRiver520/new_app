require 'rails_helper'

RSpec.describe "Boards", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:board) { create(:board, user: user) }
  before do
    login_user(other_user, '12345678', login_path)
  end
  describe "POST/board" do
    it "掲示板を作成できる" do
      board_params = {
        board: {
          title: "新しい掲示板のタイトル",
          body: "掲示板の内容"
        }
      }
      post boards_path, params: board_params
      expect(response).to redirect_to(Board.last)
    end
  end
  describe "GET /boards/new" do
    context "ログインしていると" do
      it "掲示板作成ページにアクセスできる" do
        get new_board_path
        expect(response).to have_http_status(:ok)
      end
    end
    context "ログインしていないと" do
      it "ログインページに遷移する" do
        delete logout_path
        get new_board_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(login_path)
      end
    end
  end
  describe "GET /boards/:id/edit" do
    context "所有者でアクセスする場合" do
      it "編集ページにアクセスできる" do
        login_user(user, "12345678", login_path)
        get edit_board_path(board)
        expect(response).to have_http_status(:ok)
      end
    end
    context "別のユーザーでアクセスする場合" do
      it "アクセスが拒否される" do
        get edit_board_path(board)
        expect(response).to have_http_status(:found)
      end
    end
  end
  describe "DELETE /boards/:id" do
    context "所有者でアクセスする場合" do
      it "掲示板を削除できる" do
        login_user(user, "12345678", login_path)
        delete board_path(board)
        expect(response).to redirect_to(boards_path)
      end
    end
    context "別のユーザーでアクセスする場合" do
      it "掲示板を削除できない" do
        delete board_path(board)
        expect(response).to have_http_status(:found)
      end
    end
  end
  describe "GET /board" do
    it "掲示板一覧にアクセスできること" do
      get boards_path
      expect(response).to have_http_status(:ok)
    end
  end
  describe "GET /boards/:id" do
    let(:user) { create(:user) }
    context "パスワード保護されていない掲示板の場合" do
      it "掲示板詳細にアクセスできること" do
        board = create(:board, user: user)
        get board_path(board)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(board.title)
        expect(response.body).to include(board.body)
      end
    end
    context "パスワード保護されている掲示板の場合" do
      let(:private_board) { create(:board, user: user, title: "パスワード付きのタイトル", body: "パスワード付きの本文", password_digest: BCrypt::Password.create("password123")) }
      it "パスワード未認証の場合、パスワード入力ページに遷移される" do
        get board_path(private_board)
        expect(response).to redirect_to(enter_password_board_path(private_board))
      end
      it "パスワード認証済みの場合、掲示板詳細にアクセスできる" do
        post verify_password_board_path(private_board), params: { password: "password123" }
        get board_path(private_board)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(private_board.title)
        expect(response.body).to include(private_board.body)
      end
    end
  end
end
