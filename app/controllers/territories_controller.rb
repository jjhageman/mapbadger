class TerritoriesController < ApplicationController
  respond_to :html, :json

  # GET /territories
  # GET /territories.json
  def index
    @territories = Territory.all
    @regions = Region.all_regions
    @opportunities = Opportunity.all
    respond_with(@territories)
  end

  # GET /territories/1
  # GET /territories/1.json
  def show
    @territory = Territory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @territory }
    end
  end

  # GET /territories/new
  # GET /territories/new.json
  def new
    @territory = Territory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @territory }
    end
  end

  # GET /territories/1/edit
  def edit
    @territory = Territory.find(params[:id])
  end

  # POST /territories
  # POST /territories.json
  def create
    @territory = Territory.new(params[:territory])
    if @territory.save
      respond_with(@territory)
    else
      respond_with(@territory, :status => :unprocessable_entity)
    end
  end

  # PUT /territories/1
  # PUT /territories/1.json
  def update
    @territory = Territory.find(params[:id])

    # hack to determine new and deleted regions
    adjust_region_ids      

    if @territory.update_attributes(params[:territory])
      respond_with(@territory)
    else
      respond_with(@territory, :status => :unprocessable_entity)
    end
  end

  # DELETE /territories/1
  # DELETE /territories/1.json
  def destroy
    @territory = Territory.find(params[:id])
    @territory.destroy

    respond_to do |format|
      format.html { redirect_to territories_url }
      format.json { head :ok }
    end
  end

  def adjust_region_ids
    tr = params.fetch(:territory, {}).fetch(:territory_regions_attributes, nil)
    return unless tr

    new_attrs = []
    region_ids = tr.map {|h| h['region_id'].to_i}.flatten

    new_ids = new_region_ids(@territory, region_ids)
    new_ids.each {|id| new_attrs << {"region_id"=>id.to_s}}

    deleted_assoc_ids = deleted_territory_region_ids(@territory, region_ids)
    deleted_assoc_ids.each {|id| new_attrs << {'id'=>id.to_s, '_destroy'=>'1'}}

    params[:territory][:territory_regions_attributes] = new_attrs
  end

  def new_region_ids(territory, ids)
    @persisted_ids ||= territory.region_ids
    (@persisted_ids | ids) - @persisted_ids
  end

  def deleted_territory_region_ids(territory, ids)
    @persisted_ids ||= territory.region_ids
    region_ids = (@persisted_ids | ids) - ids
    region_ids.collect{|region_id| territory.territory_regions.find_by_region_id(region_id).id}
  end
end


