class CreatePledges < ActiveRecord::Migration[6.0]
  def change
    create_table :pledges do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :twitch_username
      t.integer :twitch_id
      t.datetime :signed_on, precision: 0
      t.boolean :badge_revoked, default: false
      t.datetime :revoked_on

      t.timestamps precision: 0
    end
  end
end
