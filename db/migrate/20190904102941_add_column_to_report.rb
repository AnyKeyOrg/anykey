class AddColumnToReport < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :dismissed, :boolean, default: false
  end
end
