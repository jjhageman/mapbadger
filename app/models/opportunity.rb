class Opportunity < ActiveRecord::Base
  #FACTORY = RGeo::Geographic.simple_mercator_factory
  #set_rgeo_factory_for_column(:location, FACTORY.projection_factory)

  # set_rgeo_factory_for_column(:location,
  #   RGeo::Geographic.spherical_factory(:srid => 4326))

  def self.csv_geo_import(file)

  end

  def self.csv_import(file)
    ActiveRecord::Base.connection.execute(<<-SQL)
      COPY opportunities (name, address1, city, state, zipcode) 
      FROM '#{file.path}' CSV;
      SQL
  end
end
