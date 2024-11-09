class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      begin
        UserMailer.registration_complete(@user).deliver_now
        flash[:success] = "登録が完了しました"
        redirect_to login_path
      rescue => e
        @user.destroy
        flash[:danger] = "メール送信に失敗しました。メールアドレスを確認し、再度お試しください。"
        Rails.logger.error("メール送信エラー: #{e.message}")
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = "会員登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :profile_image, :profile_image_cache)
  end
end
