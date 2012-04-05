class OpportunitiesController < ApplicationController
  before_filter :authenticate_company!

  # GET /opportunities
  # GET /opportunities.json
  def index
    @opportunities = current_company.opportunities

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @opportunities }
    end
  end

  # GET /opportunities/1
  # GET /opportunities/1.json
  def show
    @opportunity = current_company.opportunities.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @opportunity }
    end
  end

  # GET /opportunities/new
  # GET /opportunities/new.json
  def new
    @opportunity = Opportunity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @opportunity }
    end
  end

  # GET /opportunities/1/edit
  def edit
    @opportunity = current_company.opportunities.find(params[:id])
  end

  # POST /opportunities
  # POST /opportunities.json
  def create
    @opportunity = current_company.opportunities.new(params[:opportunity])

    respond_to do |format|
      if @opportunity.save
        format.html { redirect_to @opportunity, notice: 'Opportunity was successfully created.' }
        format.json { render json: @opportunity, status: :created, location: @opportunity }
      else
        format.html { render action: "new" }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    @opportunity = Opportunity.new
  end

  def upload
    Opportunity.csv_geo_import params[:upload][:csv].read, current_company

    redirect_to opportunities_path, notice: 'Your file has been imported.'
  end

  # PUT /opportunities/1
  # PUT /opportunities/1.json
  def update
    @opportunity = current_company.opportunities.find(params[:id])

    respond_to do |format|
      if @opportunity.update_attributes(params[:opportunity])
        format.html { redirect_to @opportunity, notice: 'Opportunity was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opportunities/1
  # DELETE /opportunities/1.json
  def destroy
    @opportunity = current_company.opportunities.find(params[:id])
    @opportunity.destroy

    respond_to do |format|
      format.html { redirect_to opportunities_url }
      format.json { head :ok }
    end
  end

  def destroy_multiple
    Opportunity.destroy_all(:id => params[:opportunity_ids])

    respond_to do |format|
      format.html { redirect_to opportunities_url, notice: 'Opportunities were successfully deleted.' }
      format.json { head :ok }
    end
  end
end
