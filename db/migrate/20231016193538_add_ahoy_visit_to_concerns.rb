class AddAhoyVisitToConcerns < ActiveRecord::Migration[6.1]
  def change
    add_reference :concerns, :ahoy_visit
  end
end
