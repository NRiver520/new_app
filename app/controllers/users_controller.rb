class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_complete(@user).deliver_now
      flash[:success] = "登録が完了しました。確認メールが届かない場合は正しいアドレスで再度登録してください"
      redirect_to login_path
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
