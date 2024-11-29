class CreateSpamReports < ActiveRecord::Migration[6.1]
  def change
    create_table :spam_reports do |t|
      t.text :description
      
      t.references :report1, null: false, foreign_key: { to_table: :reports }
      t.references :report2, null: false, foreign_key: { to_table: :reports }

      t.timestamps
    end
  end
end
