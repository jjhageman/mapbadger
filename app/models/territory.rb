class Territory < ActiveRecord::Base
  has_many :territory_regions, :dependent => :destroy
  has_many :regions, :through => :territory_regions
  belongs_to :representative
  accepts_nested_attributes_for :territory_regions, :allow_destroy => true

  validates :name, :uniqueness => true

  def as_json(options = nil)
    super((options || {}).merge(include: { regions: { only: [:id, :name] }, representative: { only: [:id, :first_name, :last_name]}} ))
  end
end
