require "httparty"

namespace :pokemon do

  task :all_pokemon => [:environment] do 
    desc "used to populate pokemons"

    url = "https://pokeapi.co/api/v2/pokemon/?limit=151"
    pokemons = []
    req = HTTParty.get(url)
    pokemons = req.parsed_response["results"]

    pokemons.each do |pokemon|
      Pokemon.create(name: pokemon["name"])
    end
  end

  task :types => [:environment] do
    pokemons = Pokemon.all

    pokemons.each do |pokemon|
      url_type = "https://pokeapi.co/api/v2/pokemon/#{pokemon.id}/"
      req_type = HTTParty.get(url_type)
      pkmn_types = req_type.parsed_response["types"]

      pkmn_types.each do |type|
        type_app = Type.find_by(name: type["type"]["name"])
        if type_app
          TypesPokemon.create(pokemon_id: pokemon.id, type_id: type_app.id)
        end
      end
    end


  end

  task :evolutions => [:environment] do 

    evo_chains_url = "https://pokeapi.co/api/v2/evolution-chain/?limit=78"
    evo_chains = HTTParty.get(evo_chains_url)
    evo_chains = evo_chains.parsed_response["results"]

    evo_chains.each do |evolution_chain|
      flag_pkmn_baby = false

      pkmn_evolve = HTTParty.get(evolution_chain["url"])
      pkmn_evolve_base = pkmn_evolve.parsed_response["chain"]

      if pkmn_evolve_base["is_baby"]
        pkmn_evolve_base = pkmn_evolve.parsed_response["chain"]["evolves_to"][0]
        flag_pkmn_baby = true
        pkmn_base = Pokemon.find_by(name: pkmn_evolve_base["species"]["name"])
        evo_json = pkmn_evolve.parsed_response["chain"]["evolves_to"][0]
        evolution = pkmn_base    
      end

      has_evolution = ! flag_pkmn_baby && ! pkmn_evolve.parsed_response["chain"]["evolves_to"].empty?

      if has_evolution
        evo_json = pkmn_evolve.parsed_response["chain"]["evolves_to"][0]
        if evolution = Pokemon.find_by(name: evo_json["species"]["name"])
          pkmn_base = Pokemon.find_by(name: pkmn_evolve_base["species"]["name"])
          Evolution.create(pkmn_id: evolution.id, order: 1, pkmn_previous_stage_id: pkmn_base.id);
        end
      end

      has_second_evolution = evo_json != nil && evo_json["evolves_to"][0]

      if has_second_evolution
        second_stage_evo_json = evo_json["evolves_to"][0]
        if second_evolution = Pokemon.find_by(name: second_stage_evo_json["species"]["name"])
          second_evolution = Pokemon.find_by(name: second_stage_evo_json["species"]["name"])        
          Evolution.create(pkmn_id: second_evolution.id, order: 2, pkmn_previous_stage_id: evolution.id);
        end
      end

    end


  end


  task :success_msg => [:environment] do 
    p "Database populated with all 151 Pokemons, its evolutions and types."
  end

  task :all => [:all_pokemon, :evolutions, :types, :success_msg]
end