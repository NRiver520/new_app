class AddPasswordDigestToBoards < ActiveRecord::Migration[7.2]
  def change
    add_column :boards, :password_digest, :string
  end
end
