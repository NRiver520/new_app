class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password,confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :username, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  before_create :generate_confirmation_token

  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy

  def own?(object)
    object&.user_id == id
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    self.confirmation_sent_at = Time.now.utc
  end

  def confirmed?
    confirmed_at.present?
  end

end
