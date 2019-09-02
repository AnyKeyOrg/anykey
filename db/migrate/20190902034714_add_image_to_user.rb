class AddImageToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :image_uid, :string
  end
end
