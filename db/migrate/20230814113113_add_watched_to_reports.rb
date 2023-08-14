class AddWatchedToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :watched, :boolean, default: false
  end
end
