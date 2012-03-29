class NasdaqCompany < ActiveRecord::Base
  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:location, FACTORY.projection_factory)

  def self.all_companies
    @allcos ||= NasdaqCompany.all
  end
end
