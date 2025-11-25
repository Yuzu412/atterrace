class CreateGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.index :name, unique: true
      t.timestamps
    end
  end
end
