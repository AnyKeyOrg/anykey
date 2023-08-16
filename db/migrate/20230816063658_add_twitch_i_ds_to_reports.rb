class AddTwitchIDsToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :reporter_twitch_id, :integer
    add_column :reports, :reported_twitch_id, :integer
    add_column :reports, :incident_stream_twitch_id, :integer
  end
end
