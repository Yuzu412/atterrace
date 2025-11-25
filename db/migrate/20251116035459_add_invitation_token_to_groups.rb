class AddInvitationTokenToGroups < ActiveRecord::Migration[7.2]
  def change
    add_column :groups, :invitation_token, :string
    add_index :groups, :invitation_token, unique: true

  end
end
