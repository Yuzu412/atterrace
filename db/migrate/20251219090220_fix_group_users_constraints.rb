class FixGroupUsersConstraints < ActiveRecord::Migration[7.0]
  def change
    change_column_null :group_users, :group_id, false
    change_column_null :group_users, :user_id, false

    add_index :group_users, [:group_id, :user_id], unique: true
  end
end