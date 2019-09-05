class CreateRevocations < ActiveRecord::Migration[6.0]
  def change
    create_table :revocations do |t|
      t.integer :pledge_id
      t.integer :report_id
      t.text :reason

      t.timestamps
    end
  end
end
