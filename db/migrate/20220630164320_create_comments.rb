class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.integer :report_id
      t.integer :commenter_id
      t.text  :body
      t.integer :parent_comment_id

      t.timestamps
    end
  end
end
