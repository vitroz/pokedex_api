class PokemonSerializer < ActiveModel::Serializer
  attributes :id, :name #:types, :evolutions

  # def evolutions
  # 	if !self.object.evolutions.empty?
  #     evolutions = [
  #     {pkmn_name: Pokemon.find(self.object.evolutions[0].pkmn_id).name, 
  #     order: self.object.evolutions[0].order,
  #     pkmn_previous_stage: Pokemon.find(self.object.evolutions[0].pkmn_previous_stage_id).name}]

  #     second_evo = Evolution.find_by(pkmn_previous_stage_id: self.object.evolutions[0].pkmn_id)

  # 	  if second_evo 
  #      evolutions.push({pkmn_name: Pokemon.find(second_evo.pkmn_id).name, 
  #      order: second_evo.order,
  #      pkmn_previous_stage: Pokemon.find(second_evo.pkmn_previous_stage_id).name})
  #     end

  #   else
  #     return []
  #   end
  #     return evolutions
  # end 

end
