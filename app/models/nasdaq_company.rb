class NasdaqCompany < ActiveRecord::Base
  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:location, FACTORY.projection_factory)
end
