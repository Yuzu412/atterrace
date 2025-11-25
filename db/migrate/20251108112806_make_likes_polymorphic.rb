class MakeLikesPolymorphic < ActiveRecord::Migration[7.2]
  # 既存の tweet_id, blog_id は削除する
    remove_column :likes, :tweet_id, :integer
    remove_column :likes, :blog_id, :integer

    # polymorphic カラムを追加
    add_reference :likes, :likeable, polymorphic: true, null: false
end
