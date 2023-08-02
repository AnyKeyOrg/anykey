class CreateConcerns < ActiveRecord::Migration[6.1]
  def change
    create_table :concerns do |t|
      t.string :concerning_player_id
      t.string :concerning_player_id_type
      t.text :background
      t.text :description
      t.text :recommended_response
      t.string :concerned_email
      t.string :concerned_cert_code

      t.timestamps
    end
  end
end
