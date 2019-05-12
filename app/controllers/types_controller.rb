class TypesController < ApplicationController
  
  def show
    type = Type.find(params[:id])
    if type
      render json: type
      return
    end
      render json: {status: "error", code: 404, message: "Type not found"}
  end	

end
