class NasdaqCompaniesController < ApplicationController
  before_filter :authenticate_company!
  respond_to :html, :json

  # GET /territories
  # GET /territories.json
  def index
    @companies = NasdaqCompany.all_companies
    respond_with(@companies)
  end
end
