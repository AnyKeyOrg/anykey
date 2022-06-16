class AddReportsCountToPledge < ActiveRecord::Migration[6.0]
  def change
    add_column :pledges, :reports_count, :integer
  end
end
