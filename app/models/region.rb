class Region < ActiveRecord::Base
  has_many :zipcodes
  has_many :geometries

  def self.all_regions
    @regions ||= Region.includes([{:zipcodes => :geometries}, :geometries]).all
  end

  def opportunities
    Opportunity.joins("INNER JOIN geometries ON geometries.id IN (#{geometry_ids.join(',')}) AND st_contains(geometries.area, opportunities.location)").all
  end

  def as_json(options = nil)
    @asjson ||= super((options || {}).merge(include:{
      geometries:{only:[:id,:polyline]},
      zipcodes:{include:{
        geometries:{only:[:id,:polyline]}}}}))
  end
end
