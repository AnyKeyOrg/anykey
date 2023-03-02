class AddFlagsToVerifications < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :photo_id_submitted, :boolean, default: false
    add_column :verifications, :doctors_note_submitted, :boolean, default: false
  end
end
