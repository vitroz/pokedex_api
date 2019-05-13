class Pokemon < ApplicationRecord
  validate :check_if_exists
  has_many :evolutions, foreign_key: :pkmn_previous_stage_id, dependent: :destroy
  has_many :types_pokemon
  has_many :types, through: :types_pokemon

  validates_presence_of :name

  class_attribute :evolution_family
  self.evolution_family = []

  def check_if_exists
    if Pokemon.exists?(name: self.name)
      errors.add(:pokemon, "Pokemon with the same name already exists")
    end    
  end

  def return_evolution_family

    if not self.evolutions.empty?
      is_base = ! Evolution.find_by(pkmn_id: self.id)
      if is_base
        self.evolution_family = get_evolution_family(self)
      else
        first_evo = Evolution.find_by(pkmn_id: self.id)
        base_pkmn = Pokemon.find(Evolution.find_by(pkmn_id: self.id).pkmn_previous_stage_id)
        self.evolution_family = get_evolution_family(base_pkmn)
      end
    else
      evo = Evolution.find_by(pkmn_id: self.id)
      if evo && evo.order == 2
        second_evo = Evolution.find_by(pkmn_id: self.id)
        first_evo = Evolution.find_by(pkmn_id: second_evo.pkmn_previous_stage_id)
        base_pkmn = Pokemon.find(first_evo.pkmn_previous_stage_id)
        self.evolution_family = get_evolution_family(base_pkmn)
      end
      if evo && evo.order == 1
        first_evo = Evolution.find_by(pkmn_id: self.id)
        base_pkmn = Pokemon.find(first_evo.pkmn_previous_stage_id)
        self.evolution_family = get_evolution_family(base_pkmn)
      end
    end

    return self.evolution_family.uniq

  end

  def get_evolution_family(pkmn_subject)
    evolution_family = []

    is_base = ! Evolution.find_by(pkmn_id: pkmn_subject.id)

    if is_base && ! pkmn_subject.evolutions.empty?
      pkmn_subject.evolutions.each do |pokemon_evo|
        evo = Evolution.find_by(pkmn_id: pokemon_evo.pkmn_id)
          evolution_family.push({pkmn_id: pkmn_subject.id})
          evolution_family.push({pkmn_id: evo.pkmn_id})
        if second_evo = Evolution.find_by(pkmn_previous_stage_id: evo.pkmn_id)
          evolution_family.push({pkmn_id: second_evo.pkmn_id})
        end   
      end  
    end

    evolution_family = evolution_family.uniq { |h| h[:pkmn_id] } #eevee

    return evolution_family

  end

end
