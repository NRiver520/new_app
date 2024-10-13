class ProfilesController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "更新しました"
      redirect_to profile_path
    else
      flash.now[:danger] = "更新できませんでした"
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:username, :email, :profile_image, :profile_image_cache)
  end
end
