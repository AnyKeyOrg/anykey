class AddAhoyVisitToPledges < ActiveRecord::Migration[6.1]
  def change
    add_reference :pledges, :ahoy_visit
  end
end
