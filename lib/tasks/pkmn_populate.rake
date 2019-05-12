require "httparty"

namespace :pokemon do

  task :loading_msg  do
    p 'This might take a few moments, please wait.'
  end

  task :all_pokemon => [:environment] do 
    desc "used to populate pokemons"

    url = "https://pokeapi.co/api/v2/pokemon/?limit=151"
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
      order = 0

      pkmn_evolve = HTTParty.get(evolution_chain["url"])
      pkmn_evolve_base = pkmn_evolve.parsed_response["chain"]

      if pkmn_evolve_base["is_baby"]
        pkmn_evolve_base = pkmn_evolve.parsed_response["chain"]["evolves_to"][0]
        flag_pkmn_baby = true
        pkmn_base = Pokemon.find_by(name: pkmn_evolve_base["species"]["name"])
        evolutions = pkmn_evolve.parsed_response["chain"]["evolves_to"]
        evolution = pkmn_base    
      end  

      has_evolution = ! flag_pkmn_baby && ! pkmn_evolve.parsed_response["chain"]["evolves_to"].empty?  

      if has_evolution
        evolutions = pkmn_evolve.parsed_response["chain"]["evolves_to"]
        order += 1  

        evolutions.each do |evolution_pkmn|
          if evolution = Pokemon.find_by(name: evolution_pkmn["species"]["name"])
            pkmn_base = Pokemon.find_by(name: pkmn_evolve_base["species"]["name"])
            Evolution.create(pkmn_id: evolution.id, order: order, pkmn_previous_stage_id: pkmn_base.id);
          end
        end  

      end  

      has_second_evolution = evolutions != nil && ! evolutions[0]["evolves_to"].empty?  

      if has_second_evolution
        second_stage_evo_json = evolutions[0]["evolves_to"][0]
        if second_evolution = Pokemon.find_by(name: second_stage_evo_json["species"]["name"])
          order += 1      
          Evolution.create(pkmn_id: second_evolution.id, order: order, pkmn_previous_stage_id: evolution.id);
        end
      end  


    end
    
  end

  task :success_msg => [:environment] do 
    p "Database populated with all 151 Pokemons, its evolutions and types."
  end

  task :all => [:loading_msg, :all_pokemon, :evolutions, :types, :success_msg]
end