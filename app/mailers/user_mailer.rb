class UserMailer < ApplicationMailer
  default from: "no-reply@yourapp.com"

  def registration_confirmation(user)
    @user = user
    @confirmation_url = confirm_email_url(token: @user.confirmation_token) # 確認用URLを生成
    mail(to: @user.email, subject: "会員登録の確認")
  end
end
