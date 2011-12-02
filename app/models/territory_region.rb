class TerritoryRegion < ActiveRecord::Base
  belongs_to :territory
  belongs_to :region
end
