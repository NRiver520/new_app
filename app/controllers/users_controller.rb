class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      redirect_to login_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])

    if user && user.confirmation_sent_at >= 2.days.ago
      user.update(confirmed_at: Time.current, confirmation_token: nil)
      redirect_to login_path
    else
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
