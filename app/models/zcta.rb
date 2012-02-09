class Zcta < ActiveRecord::Base
  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:region, FACTORY.projection_factory)
  
  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
    :emit_ewkb_srid => true, :hex_format => true)

  def self.containing_latlon(lat, lon)
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    where("ST_Intersects(region, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
  end
end
