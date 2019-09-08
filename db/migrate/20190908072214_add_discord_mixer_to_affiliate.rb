class AddDiscordMixerToAffiliate < ActiveRecord::Migration[6.0]
  def change
    add_column :affiliates, :discord, :string
    add_column :affiliates, :mixer, :string
  end
end
