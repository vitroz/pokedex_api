class PokemonSerializer < ActiveModel::Serializer
  attributes :id, :name, :evolution_family

  has_many :types_pokemon, serializer: TypesPokemonSerializer
  has_many :evolutions, serializer: EvolutionSerializer
end
