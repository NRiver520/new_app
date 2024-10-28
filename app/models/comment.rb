class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 65_535 }
  belongs_to :user
  belongs_to :board

  after_create :increment_comment_count
  mount_uploader :comment_image, CommentImageUploader

  private

  def increment_comment_count
    user.increment!(:comments_count)
  end
end
