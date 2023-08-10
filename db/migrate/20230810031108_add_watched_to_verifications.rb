class AddWatchedToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :watched, :boolean, default: false
  end
end
