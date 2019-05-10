class PokemonsController < ApplicationController

  def index
    @pokemons = Pokemon.all
    if not @pokemons.empty?
      render json: @pokemons
      return
    end
    render json: {status: "error", code: 404, message: "Pokemons not found"}
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    if @pokemon
      render json: @pokemon
      return
    end
      render json: {status: "error", code: 404, message: "Pokemon not found"}
  end

  def update
    @pokemon = Pokemon.find(params[:id])

    if @pokemon.update(pkmn_params)
      render json: {status: "success", code: 200, message: "Pokemons updated"}
      return
    end
      render json: {status: "error", code: 500, message: "Error updating Pokemon"}
  end

  def destroy
    @pokemon = Pokemon.find(params[:id])
    if @pokemon
      @pokemon.destroy
      render json: {status: "success", code: 200, message: "Pokemon deleted successfully"}
      return
    end
      render json: {status: "error", code: 404, message: "Error finding Pokemon to destroy"}
  end

  private
  def pkmn_params
    params.require(:pokemon).permit(:name, :type, :url, :full_info)
  end

end
