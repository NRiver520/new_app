class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :username, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :email, presence: true, uniqueness: true

  before_create :generate_confirmation_token

  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy
  mount_uploader :profile_image, ProfileImageUploader

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

  def rank
    case comments_count
    when nil
      "ノーランク"
    when 1..50
      "ブロンズ"
    when 51..200
      "シルバー"
    when 201..500
      "ゴールド"
    else
      "プラチナ"
    end
  end
end
