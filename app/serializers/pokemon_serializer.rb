class PokemonSerializer < ActiveModel::Serializer
  attributes :id, :name, :types, :evolutions, :evolution_family
end
