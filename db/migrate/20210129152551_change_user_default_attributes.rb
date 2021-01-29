class ChangeUserDefaultAttributes < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :is_moderator, :boolean, default: true
  end
end
