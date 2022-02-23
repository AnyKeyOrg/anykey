class CreateTwitchTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :twitch_tokens do |t|
      t.string :access_token
      t.integer :expires_in

      t.timestamps
    end
  end
end
