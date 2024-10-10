class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create confirm_email]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "確認メールを送信しました"
      UserMailer.registration_confirmation(@user).deliver_now
      redirect_to login_path
    else
      flash.now[:danger] = "会員登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])

    if user && user.confirmation_sent_at >= 2.days.ago
      flash[:success] = "アカウントが有効化されました。ログインしてください"
      user.update(confirmed_at: Time.current, confirmation_token: nil)
      redirect_to login_path
    else
      flash[:danger] = "確認リンクの期限が切れています"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
