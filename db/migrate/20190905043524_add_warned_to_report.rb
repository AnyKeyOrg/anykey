class AddWarnedToReport < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :warned, :boolean, default: false
  end
end
