class AddColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :is_admin, :boolean, default: false
    add_column :users, :is_moderator, :boolean, default: false
  end
end
