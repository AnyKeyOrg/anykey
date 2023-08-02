class AddSharedOnAndReviewerToConcerns < ActiveRecord::Migration[6.1]
  def change
    add_column :concerns, :shared_on, :datetime
    add_column :concerns, :reviewed_on, :datetime
    add_column :concerns, :reviewer_id, :integer
  end
end
