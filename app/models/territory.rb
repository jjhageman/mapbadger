class Territory < ActiveRecord::Base
  has_many :territory_regions
  has_many :regions, :through => :territory_regions
  accepts_nested_attributes_for :territory_regions, :allow_destroy => true

  validates :name, :uniqueness => true

  def as_json(options = nil)
    super((options || {}).merge(include: { regions: { only: [:id, :name] } }))
  end
end
