class SetCommentCountDefaults < ActiveRecord::Migration[6.1]
  def change
    change_column_default :verifications, :comments_count, 0
    change_column_default :concerns, :comments_count, 0
    change_column_default :reports, :comments_count, 0
  end
end
