class Evolution < ApplicationRecord
  validate :check_pokemons_are_the_same, :check_if_exists
  belongs_to :pokemon, foreign_key: :pkmn_previous_stage_id, dependent: :destroy

  def check_pokemons_are_the_same
    if self.pkmn_id == self.pkmn_previous_stage_id
      errors.add(:evolution, "pokemons involved must be different")
    end
  end

  def check_if_exists
    if Evolution.find_by(pkmn_id: self.pkmn_id)
      errors.add(:evolution, "Pokemon #{self.pkmn_id.to_s} already involved in an evolution")
    end
  end

end
