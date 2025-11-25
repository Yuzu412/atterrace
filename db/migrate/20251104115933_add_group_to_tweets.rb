class AddGroupToTweets < ActiveRecord::Migration[7.2]
  def change
    add_reference :tweets, :group, foreign_key: true
  end
end
