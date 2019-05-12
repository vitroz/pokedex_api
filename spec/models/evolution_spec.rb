require 'rails_helper'

RSpec.describe Evolution, :type => :model do

  describe "Evolution tests!" do
    it "create a new evolution association on two diferent pokemons" do

      pokemon = Pokemon.create(:name => "Pkmn")
      pkmn_evolution = Pokemon.create(:name => "Pkmn Evo")

      evolution = Evolution.create(
      	pkmn_id: pokemon.id, 
      	order: 1,
      	pkmn_previous_stage_id: pkmn_evolution.id)

      expect(evolution.errors).to be_empty
    end

    it "fails to create an evolution if pokemons involved are the same" do

      pokemon = Pokemon.create(:name => "Pkmn")
      pkmn_evolution = Pokemon.create(:name => "Pkmn Evo")

      evolution = Evolution.create(
      	pkmn_id: pokemon.id, 
      	order: 1,
      	pkmn_previous_stage_id: pokemon.id)

      expect(evolution.errors).not_to be_empty
    end

    it "fails to create an evolution if there is already an evolution created with the same pokemon involved" do

      pokemon = Pokemon.create(:name => "Pkmn")
      pkmn_evolution = Pokemon.create(:name => "Pkmn Evo")

      evolution = Evolution.create(
      	pkmn_id: pokemon.id, 
      	order: 1,
      	pkmn_previous_stage_id: pkmn_evolution.id)

      same_evolution_twice = Evolution.create(
      	pkmn_id: pokemon.id, 
      	order: 1,
      	pkmn_previous_stage_id: pkmn_evolution.id)

      expect(same_evolution_twice.errors).not_to be_empty
    end

  end

  describe Evolution do
    it { should belong_to(:pokemon) }
  end

end