class Opportunity < ActiveRecord::Base
  belongs_to :company
  before_save :sync_location, :if => :lat_lng_changed_but_not_location?
  before_save :sync_lat_lng, :if => :location_changed_but_not_lat_lng?

  # Create a simple mercator factory. This factory itself is
  # geographic (latitude-longitude) but it also contains a
  # companion projection factory that uses EPSG 3785.
  FACTORY = RGeo::Geographic.simple_mercator_factory

  # We're storing data in the database in the projection.
  # So data gotten straight from the "loc" attribute will be in
  # projected coordinates.
  set_rgeo_factory_for_column(:location, FACTORY.projection_factory)

  def regions
    Region.joins("INNER JOIN opportunities on opportunities.id=#{id}
                 INNER JOIN geometries ON geometries.region_id = regions.id
                 AND st_contains(geometries.area, opportunities.location)").all
  end

  def zipcodes
    Zipcode.joins("INNER JOIN opportunities on opportunities.id=#{id}
                 INNER JOIN geometries ON geometries.zipcode_id = zipcodes.id
                 AND st_contains(geometries.area, opportunities.location)").all
  end

  # To interact in projected coordinates, just use the "loc"
  # attribute directly.
  def loc_projected
    self.location
  end

  def loc_projected=(value)
    self.location = value
  end

  # To use geographic (lat/lon) coordinates, convert them using
  # the wrapper factory.
  def loc_geographic
    FACTORY.unproject(self.location)
  end
  def loc_geographic=(value)
    self.location = FACTORY.project(value)
  end
 
  def lat_lng_changed_but_not_location?
    (lng_changed? || lat_changed?) && !location_changed?
  end

  def location_changed_but_not_lat_lng?
    location_changed? && !lng_changed? && !lat_changed?
  end

  # Callback: before_save if location_changed_but_not_lat_lng?
  def sync_lat_lng
    self.lng = loc_geographic.x
    self.lat = loc_geographic.y
  end

  # Callback: before_save if lat_lng_changed_but_not_location?
  def sync_location
    point = FACTORY.point(self.lng, self.lat)
    self.loc_geographic = point
  end

  # CSV Import functionality
  def self.csv_geo_import(data, company)
    CSV.parse(data, :headers => true, :header_converters => :downcase) do |row|
      company.opportunities.create :name => row['name'],
        :address1 => row['address'],
        :city => row['city'],
        :state => row['state'],
        :zipcode => row['zipcode'],
        :lat => row['latitude'],
        :lng => row['longitude']
    end
  end

  def self.csv_import(data, company)
    CSV.parse(data, {:headers => true}) do |row|
      company.opportunities.create :name => row[0],
        :address1 => row[1],
        :city => row[2],
        :state => row[3],
        :zipcode => row[4]
    end
  end
end
