class Geometry < ActiveRecord::Base
  belongs_to :region
  belongs_to :zipcode

  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:area, FACTORY.projection_factory)
  
  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
    :emit_ewkb_srid => true, :hex_format => true)

  def self.containing_latlon(lat, lon)
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    where("ST_Intersects(area, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
  end

  def self.in_rect(w, s, e, n)
    # Create lat-lon points, and then get the projections.
    sw = FACTORY.point(w, s).projection
    ne = FACTORY.point(e, n).projection
    # Now we can create a scope for this query.
    where("area && '#{sw.x},#{sw.y},#{ne.x},#{ne.y}'::box")
  end

  def loc_geographic
    FACTORY.unproject(self.area)
  end

  def as_json(options=nil)
    super((options || {}).merge(only: [:id, :polyline]))
  end
end
