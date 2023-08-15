class AddScreenshotsSubmittedCountToConcerns < ActiveRecord::Migration[6.1]
  def change
    add_column :concerns, :screenshots_submitted_count, :integer
  end
end
