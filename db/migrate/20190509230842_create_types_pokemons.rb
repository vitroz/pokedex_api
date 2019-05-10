class CreateTypesPokemons < ActiveRecord::Migration[5.2]
  def change
    create_table :types_pokemons do |t|
      t.references :pokemon, foreign_key: true
      t.references :type, foreign_key: true

      t.timestamps
    end
  end
end
