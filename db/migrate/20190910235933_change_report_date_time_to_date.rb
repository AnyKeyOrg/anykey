class ChangeReportDateTimeToDate < ActiveRecord::Migration[6.0]
  def up
    change_column :reports, :incident_occurred, :date
  end

  def down
    change_column :reports, :incident_occurred, :datetime
  end
end
