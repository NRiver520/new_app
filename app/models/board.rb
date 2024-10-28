class Board < ApplicationRecord
  has_secure_password validations: false

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :password, length: { minimum: 3, maximum: 255 }, allow_nil: true, allow_blank: true, if: -> { password.present? }

  belongs_to :user
  has_many :comments, dependent: :destroy
  mount_uploader :board_image, BoardImageUploader

  def self.ransackable_attributes(auth_object = nil)
    [ "title" ]
  end
end
