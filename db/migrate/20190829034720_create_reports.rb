class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :reporter_email
      t.string :reporter_twitch_name
      t.string :reported_twitch_name
      t.string :image_uid
      t.string :incident_stream
      t.datetime :incident_occurred
      t.text :incident_description
      t.text :desired_outcome

      t.timestamps
    end
  end
end
