class Territory < ActiveRecord::Base
  has_many :territory_regions, :dependent => :destroy
  has_many :regions, :through => :territory_regions
  has_many :territory_zipcodes, :dependent => :destroy
  has_many :zipcodes, :through => :territory_zipcodes
  belongs_to :representative
  accepts_nested_attributes_for :territory_regions, :allow_destroy => true
  accepts_nested_attributes_for :territory_zipcodes, :allow_destroy => true

  validates :name, :uniqueness => true

  def as_json(options = nil)
    super((options || {}).merge(include:
      { regions: { only: [:id, :name] },
        zipcodes: { only: [:id, :name] },
        representative: { only: [:id, :first_name, :last_name]}
      } ))
  end
end
