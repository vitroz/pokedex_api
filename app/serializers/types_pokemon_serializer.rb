class TypesPokemonSerializer < ActiveModel::Serializer
  attributes :type

  def type
    Type.find(self.object.type_id).name
  end
end
