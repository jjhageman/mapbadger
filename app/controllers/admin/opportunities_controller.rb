module Admin
  class OpportunitiesController < BaseController
    def import
    end
    
    def upload
      company = Company.find(params[:upload][:company_id])
      Opportunity.csv_geo_import params[:upload][:csv].read, company
      redirect_to opportunities_path, notice: 'File has been imported.'
    end
  end
end
