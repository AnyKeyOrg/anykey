class AddReviewerToRevocation < ActiveRecord::Migration[6.0]
  def change
    add_reference :revocations, :reviewer, references: :users, index: true
    add_foreign_key :revocations, :users, column: :reviewer_id
  end
end
