class AddIndicesToReports < ActiveRecord::Migration[6.1]
  def change
    add_index :reports, :reporter_email
    add_index :reports, :reporter_twitch_id
    add_index :reports, :reported_twitch_id
  end
end
