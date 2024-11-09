class UserMailer < ApplicationMailer
  default from: "no-reply@yourapp.com"

  def registration_complete(user)
    @user = user
    mail(to: @user.email, subject: "ユーザー登録が完了しました")
  end
end
