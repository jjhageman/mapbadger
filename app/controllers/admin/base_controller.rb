module Admin
  class BaseController < ApplicationController
    before_filter  :authenticate_company!, :verify_admin
    
    private
    def verify_admin
      redirect_to root_url, :alert => "You are not authorized this page." unless current_company && current_company.admin?
    end
  end
end
