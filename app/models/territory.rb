class Territory < ActiveRecord::Base
  has_many :territory_regions
  has_many :regions, :through => :territory_regions
  accepts_nested_attributes_for :territory_regions, :allow_destroy => true
end
