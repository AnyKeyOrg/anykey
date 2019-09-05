class AddReviewerToConductWarning < ActiveRecord::Migration[6.0]
  def change
    add_reference :conduct_warnings, :reviewer, references: :users, index: true
    add_foreign_key :conduct_warnings, :users, column: :reviewer_id
  end
end
