class AddCommentImageToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :comment_image, :string
  end
end
