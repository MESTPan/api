class ErrorsController < ApplicationController
  def routing
    render json: {"error":"No route matches [#{request.method}] #{request.path}"}, status: 404
  end
end