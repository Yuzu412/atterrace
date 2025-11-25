class MakeCommentsPolymorphic < ActiveRecord::Migration[7.2]
  def change
    remove_column :comments, :tweet_id, :integer, if_exists: true
    add_reference :comments, :commentable, polymorphic: true, null: false
  end
end
