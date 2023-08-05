class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :commenter_id
      t.integer :commentable_id
      t.string :commentable_type
      t.datetime :posted_on
      t.text :body

      t.timestamps
    end
  end
end
