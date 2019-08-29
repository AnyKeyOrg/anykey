class AddTimezoneToReport < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :timezone, :string
  end
end
