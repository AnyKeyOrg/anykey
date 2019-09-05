class AddRevokedToReport < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :revoked, :boolean, default: false
  end
end
