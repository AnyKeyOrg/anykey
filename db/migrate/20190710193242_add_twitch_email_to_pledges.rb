class AddTwitchEmailToPledges < ActiveRecord::Migration[6.0]
  def change
    add_column :pledges, :twitch_email, :string
  end
end
