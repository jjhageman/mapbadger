class Region < ActiveRecord::Base
  has_many :zipcodes

  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:area, FACTORY.projection_factory)
  
  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
    :emit_ewkb_srid => true, :hex_format => true)

  def self.all_regions
    @regions ||= Region.includes(:zipcodes).all
  end

  def as_json(options = nil)
    super((options || {}).merge(include: { zipcodes: { only: [:id, :name, :polyline] } }))
  end
end
