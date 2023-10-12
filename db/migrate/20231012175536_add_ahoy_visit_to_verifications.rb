class AddAhoyVisitToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_reference :verifications, :ahoy_visit
  end
end
