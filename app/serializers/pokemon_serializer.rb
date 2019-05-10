class PokemonSerializer < ActiveModel::Serializer
  attributes :id, :name, :types, :evolutions
end
