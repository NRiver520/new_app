class ContactForm
  include ActiveModel::Model
  attr_accessor :email, :body

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :body, presence: true

  def submit
    return false unless valid?
    ContactMailer.send_inquiry(self).deliver_now
  end
end
