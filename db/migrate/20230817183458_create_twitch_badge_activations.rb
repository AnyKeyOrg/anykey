class CreateTwitchBadgeActivations < ActiveRecord::Migration[6.1]
  def change
    create_table :twitch_badge_activations do |t|
      t.string :twitch_username
      t.integer :twitch_id
      t.datetime :activated_on
      t.integer :activator_id

      t.timestamps
    end
  end
end
