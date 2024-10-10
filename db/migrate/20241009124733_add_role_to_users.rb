class AddRoleToUsers < ActiveRecord::Migration[7.2]
  def change
    t.integer "role", default: 0, null: false
  end
end
