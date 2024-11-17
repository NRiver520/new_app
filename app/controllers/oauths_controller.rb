class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if params[:error].present?
      flash[:danger] = "ログインがキャンセルされました。再度お試しください。"
      redirect_to root_path
      return
    end
    
    @user = login_from(provider)
    if @user
      Rails.logger.debug("User found: #{@user.inspect}")
      flash[:success] = "#{provider.titleize}アカウントでログインしました"
      redirect_to root_path
    else
      begin
        signup_and_login(provider)
        flash[:success] = "#{provider.titleize}アカウントで新規登録しました,ユーザーネームを設定してください"
        redirect_to edit_profile_path(@profile)
      rescue
        flash[:danger] = "#{provider.titleize}アカウントでのログインに失敗しました"
        redirect_to root_path
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

  def signup_and_login(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
  end
end
