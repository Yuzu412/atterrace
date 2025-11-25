class AddUserIdToBlogs < ActiveRecord::Migration[7.2]
  def change
    add_reference :blogs, :user, null: false, foreign_key: true
  end
end
