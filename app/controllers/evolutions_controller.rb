class EvolutionsController < ApplicationController

  def create
  	req_params = JSON.parse(request.body.read)

    evolution = EvolutionService.new(req_params["evolution"]).call

    if evolution.save
      render json: {status: "success", code: 200, message: "Evolution created!"}
      return
    end
    render json: {status: "error", code: 500, message: "Evolution Failed "+ evolution.errors.full_messages.to_s}
  end	

end
