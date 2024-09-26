class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end
  
  def create
    @user = login(params[:email], params[:password])

    if @user
      if @user.confirmed?
        flash[:success] = 'ログインしました'
        redirect_to root_path
      else
        logout
        flash.now[:danger] = 'メールアドレスが確認されていません。確認メールをチェックしてください。'
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = 'ログアウトしました'
    redirect_to root_path, status: :see_other
  end
end
