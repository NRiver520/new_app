class ContactsController < ApplicationController
  def new
    @contact = ContactForm.new
  end

  def create
    @contact = ContactForm.new(contact_params)
    if @contact.submit
      flash[:success] = "お問い合わせが送信されました"
      redirect_to root_path
    else
      flash.now[:danger] = "送信に失敗しました"
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact_form).permit(:email, :body)
  end
end
