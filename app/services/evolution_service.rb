class EvolutionService

  def initialize(params)
    @pkmn_base = params["pkmn_base"]
    @evolution = params["pkmn_id"]
    @order = 1
  end

  def call

    is_evo = Evolution.find_by(pkmn_id: @evolution)
    if is_evo
      if is_evo.order == 2
        render json: {status: "error", code: 500, message: "Evolution is already at final stage"}
        return
      end
      @order = 2
    end

    Evolution.new(pkmn_id: @evolution, 
      order: @order, 
      pkmn_previous_stage_id: @pkmn_base)   
  end

end