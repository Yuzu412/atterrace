class AddGroupIdToBlogs < ActiveRecord::Migration[7.2]
  def change
    add_column :blogs, :group_id, :integer
  end
end
