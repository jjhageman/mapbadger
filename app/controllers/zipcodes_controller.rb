class ZipcodesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json

  def index
    if params[:bb]
      respond_with Zipcode.in_bb(params[:bb])
    else
      respond_with Zipcode.all
    end
  end
end
