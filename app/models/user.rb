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

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications
  attr_accessor :remember_token

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end


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
