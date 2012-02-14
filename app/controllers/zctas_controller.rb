class ZctasController < ApplicationController
  respond_to :html, :json

  def index
    if params[:bb]
      respond_with Zcta.in_bb(params[:bb])
    else
      respond_with Zcta.all
    end
  end
end
