class CreateEvolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :evolutions do |t|
      t.integer :pkmn_id
      t.integer :order
      t.integer :pkmn_previous_stage_id, foreign_key: true

      t.timestamps
    end
  end
end