class RenameTwitchBadgeActivationsToBadgeActivations < ActiveRecord::Migration[6.1]
  def change
    rename_table :twitch_badge_activations, :badge_activations
  end
end
