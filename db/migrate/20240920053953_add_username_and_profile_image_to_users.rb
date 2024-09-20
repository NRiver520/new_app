class AddUsernameAndProfileImageToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :profile_image, :string

    add_index :users, :username,unique: true
  end
end
