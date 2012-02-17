class Zcta < ActiveRecord::Base
  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:region, FACTORY.projection_factory)
  
  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
    :emit_ewkb_srid => true, :hex_format => true)

  def self.containing_latlon(lat, lon)
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    where("ST_Intersects(region, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
  end

  def loc_geographic
    FACTORY.unproject(self.region)
  end

  def kml_region
    connection.execute("SELECT ST_AsKML(ST_GeomFromText('#{region}',3785))").first['st_askml']
  end

  def points_to_mvc(points)
    points.map{ |p| "new google.maps.LatLng(#{p.y},#{p.x})" }.join(',')
  end

  def region_to_mvc
    boundary = loc_geographic.boundary
    case boundary
    when RGeo::Feature::LineString
      '['+points_to_mvc(boundary.points)+']'
    when RGeo::Feature::MultiLineString
      boundary.map {|b| points_to_mvc(b.points) }
    end 
  end

  def self.all_zipcodes
    @zipcodes ||= Zcta.all
  end

  def self.in_bb(bb)
    puts bb
  end

  def self.in_rect(w, s, e, n)
    # Create lat-lon points, and then get the projections.
    sw = FACTORY.point(w, s).projection
    ne = FACTORY.point(e, n).projection
    # Now we can create a scope for this query.
    where("region && '#{sw.x},#{sw.y},#{ne.x},#{ne.y}'::box")
  end

  def as_json(options=nil)
    super((options || {}).merge(:except => :region))
  end
end
