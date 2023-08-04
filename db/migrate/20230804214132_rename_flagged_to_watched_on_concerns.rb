class RenameFlaggedToWatchedOnConcerns < ActiveRecord::Migration[6.1]
  def change
    rename_column :concerns, :flagged, :watched
  end
end
