class AddCommentsCountToConcerns < ActiveRecord::Migration[6.1]
  def change
    add_column :concerns, :comments_count, :integer
  end
end
