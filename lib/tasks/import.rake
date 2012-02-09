require 'rgeo-shapefile'

namespace :import do
  desc "Import shape files"
  task :shapefiles, [:filename] => :environment do |task,args|
    smf = RGeo::Geographic.simple_mercator_factory
    RGeo::Shapefile::Reader.open(args[:filename], :factory => smf) do |file|
      file.each do |record|
        zcta = record['ZCTA5CE10'].to_i
        # The record geometry is a MultiPolygon. Iterate over its parts.
        record.geometry.projection.each do |poly|
          Zcta.create(:zcta => zcta, :region => poly)
        end
      end
    end
  end

  desc "Import regions from csv file"
  task :regions, [:filename] => :environment do |task,args|
    lines = File.new(args[:filename]).readlines
    keys = [:fipscode, :name, :coords]

    lines.each do |line|
      params = {}
      values = line.strip.split(';')
      keys.each_with_index do |key,i|
        params[key] = values[i+1].gsub( /\A"/m, "" ).gsub( /"\Z/m, "" )
      end
      # puts params
      Region.create(params)
    end
  end
end
