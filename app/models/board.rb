class Board < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  belongs_to :user
  has_many :comments, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "title" ]
  end
end
