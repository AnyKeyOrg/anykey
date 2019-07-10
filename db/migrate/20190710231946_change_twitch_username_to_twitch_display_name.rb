class ChangeTwitchUsernameToTwitchDisplayName < ActiveRecord::Migration[6.0]
  def change
    rename_column :pledges, :twitch_username, :twitch_display_name
  end
end
