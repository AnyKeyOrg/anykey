class AddIdentifierToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :identifier, :string
  end
end
