class AddCommentsCountToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :comments_count, :integer
  end
end
