class AddIndicesToPledges < ActiveRecord::Migration[6.1]
  def change
    add_index :pledges, :email
    add_index :pledges, :identifier
    add_index :pledges, :twitch_id
  end
end
