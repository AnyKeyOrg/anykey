class AddReviewerToReport < ActiveRecord::Migration[6.0]
  def change
    add_reference :reports, :reviewer, references: :users, index: true
    add_foreign_key :reports, :users, column: :reviewer_id
  end
end
