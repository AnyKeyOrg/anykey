class AddIndexToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_index :verifications, :identifier
  end
end
