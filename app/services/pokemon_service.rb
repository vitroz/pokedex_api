class PokemonService

  def initialize(params)
    @name = params["name"]
    @types = params["types"]
  end

  def call

    if types[0]["id"] == "" && types[1]["id"] == ""
      render json: {status: "error", code: 500, message: "Cannot create pokemon without type!"}
      return
    end

    Pokemon.new(name: @name)   
  end

end