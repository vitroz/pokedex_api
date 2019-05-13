class PokemonsController < ApplicationController

  def index
    @pokemons = Pokemon.all
    if not @pokemons.empty?
      render json: @pokemons, each_serializer: AllPokemonSerializer
      return
    end
    render json: {status: "error", code: 404, message: "Pokemons not found"}
  end

  def show
    pokemon = Pokemon.find(params[:id])
    if pokemon
      pokemon.return_evolution_family
      render json: pokemon 
      return
    end
      render json: {status: "error", code: 404, message: "Pokemon not found"}
  end

  def create
    pokemon = Pokemon.new(pkmn_params)
    req_params = JSON.parse(request.body.read)
    types = req_params["types"]
    evolutions = req_params["evolutions"]
 
    if pokemon.save
      types.each do |type|
        TypesPokemon.create(pokemon_id: pokemon.id, type_id: type["id"])
      end

      evolutions.each do |evolution|
        evolution = Evolution.create(
          pkmn_id: evolution["pkmn_id"], 
          order: evolution["order"], 
          pkmn_previous_stage_id: evolution["pkmn_previous_stage_id"])
      end
      render json: {status: "success", code: 200, message: "Pokemon created!"}
      return
    end
      render json: {status: "error", code: 500, message: "Error creating pokemon! " + pokemon.errors.full_messages.to_s}
  end

  def update
    pokemon = Pokemon.find(params[:id])

    if pokemon.update(pkmn_params)
      render json: {status: "success", code: 200, message: "Pokemons updated"}
      return
    end
      render json: {status: "error", code: 500, message: "Error updating Pokemon"}
  end

  def destroy
    pokemon = Pokemon.find(params[:id])
    if pokemon
      pokemon.destroy
      render json: {status: "success", code: 200, message: "Pokemon deleted successfully"}
      return
    end
      render json: {status: "error", code: 404, message: "Error finding Pokemon to destroy"}
  end

  private
  def pkmn_params
    params.require(:pokemon).permit(:name)
  end

end
