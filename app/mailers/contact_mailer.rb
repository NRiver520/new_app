class ContactMailer < ApplicationMailer
  default from: "no-reply@yourapp.com"
  def send_inquiry(contact)
    @contact = contact
    mail(
      to: "zhangpingchuanxi@gmail.com",
      subject: "お問い合わせ",
      body: "お問い合わせ内容:\n#{@contact.body}\n\n送信者のメールアドレス: #{@contact.email}"
    )
  end
end