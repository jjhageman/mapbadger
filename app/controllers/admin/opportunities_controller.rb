module Admin
  class OpportunitiesController < BaseController
    before_filter :load_company, except: :import

    def index
      @opportunities = @company.opportunities.order(:created_at)
    end

    def import
    end
    
    def upload
      Opportunity.csv_geo_import params[:csv].read, @company
      redirect_to admin_company_opportunities_path(@company), notice: 'File has been imported.'
    end

    def notify_company
      ContactMailer.csv_processed_alert(@company).deliver
      redirect_to admin_company_opportunities_path(@company), notice: 'A notification email has been sent to the customer.'
    end

    private

    def load_company
      @company = Company.find(params[:company_id])
    end
  end
end
