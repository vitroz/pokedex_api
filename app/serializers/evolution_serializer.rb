class EvolutionSerializer < ActiveModel::Serializer
  attributes :pkmn_id, :order, :pkmn_previous_stage_id
end
