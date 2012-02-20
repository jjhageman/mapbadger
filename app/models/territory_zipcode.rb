class TerritoryZipcode < ActiveRecord::Base
  belongs_to :territory
  belongs_to :zipcode
end
