class AddAhoyVisitToReports < ActiveRecord::Migration[6.1]
  def change
    add_reference :reports, :ahoy_visit
  end
end
