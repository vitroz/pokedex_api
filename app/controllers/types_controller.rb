class TypesController < ApplicationController
  def index
    types = Type.all
    if types
      render :json => { :status => "success", :data => types }
      return
    end
      render json: {status: "error", code: 404, message: "Types not found"}
  end


  def show
    type = Type.find(params[:id])
    if type
      render json: type
      return
    end
      render json: {status: "error", code: 404, message: "Type not found"}
  end	

end
