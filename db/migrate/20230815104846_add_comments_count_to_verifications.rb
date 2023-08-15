class AddCommentsCountToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :comments_count, :integer
  end
end
