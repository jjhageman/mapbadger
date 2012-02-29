class Territory < ActiveRecord::Base
  has_many :territory_regions, :dependent => :destroy
  has_many :regions, :through => :territory_regions, :include => :geometries
  has_many :territory_zipcodes, :dependent => :destroy
  has_many :zipcodes, :through => :territory_zipcodes, :include => :geometries
  belongs_to :representative
  accepts_nested_attributes_for :territory_regions, :allow_destroy => true
  accepts_nested_attributes_for :territory_zipcodes, :allow_destroy => true

  validates :name, :uniqueness => true

  def bounding_box
    points = regions.flat_map {|r| r.geometries.flat_map {|g| g.area.exterior_ring.points}}
    bbox_points = points.map{ |p| RGeo::Feature.cast(p, Geometry::FACTORY) }
    bbox = RGeo::Geographic::ProjectedWindow.bounding_points(bbox_points)
    [bbox.sw_point,bbox.ne_point]
  end

  def as_json(options = nil)
    super((options || {}).merge(include:
      { regions: { only: [:id, :name] },
        zipcodes: { only: [:id, :name] },
        representative: { only: [:id, :first_name, :last_name]}
      } ))
  end
end
