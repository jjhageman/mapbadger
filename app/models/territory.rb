class Territory < ActiveRecord::Base
  has_many :territory_regions
  has_many :regions, :through => :territory_regoins
end
