class Opportunity < ActiveRecord::Base
  belongs_to :company
  #FACTORY = RGeo::Geographic.simple_mercator_factory
  #set_rgeo_factory_for_column(:location, FACTORY.projection_factory)

  # set_rgeo_factory_for_column(:location,
  #   RGeo::Geographic.spherical_factory(:srid => 4326))

  def self.csv_geo_import(data, company)
    CSV.parse(data, {:headers => true}) do |row|
      company.opportunities.create :name => row[0],
        :address1 => row[1],
        :city => row[2],
        :state => row[3],
        :zipcode => row[4],
        :lat => row[5],
        :lng => row[6]
    end
  end

  def self.csv_import(data, company)
    CSV.parse(data, {:headers => true}) do |row|
      company.opportunities.create :name => row[0],
        :address1 => row[1],
        :city => row[2],
        :state => row[3],
        :zipcode => row[4]
    end
  end
end
