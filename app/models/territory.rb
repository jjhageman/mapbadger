class Territory < ActiveRecord::Base
  has_many :territory_regions
  has_many :regions, :through => :territory_regoins
  accepts_nested_attributes_for :territory_regions, :allow_destroy => true
end
