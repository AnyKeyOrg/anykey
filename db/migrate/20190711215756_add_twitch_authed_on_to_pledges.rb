class AddTwitchAuthedOnToPledges < ActiveRecord::Migration[6.0]
  def change
    add_column :pledges, :twitch_authed_on, :datetime, precision: 0
  end
end
