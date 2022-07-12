class AddTwitchIdToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :twitch_id, :integer
  end
end
