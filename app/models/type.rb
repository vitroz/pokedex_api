class Type < ApplicationRecord
  has_many :types_pokemon
  has_many :pokemons, through: :types_pokemon, dependent: :destroy
end

