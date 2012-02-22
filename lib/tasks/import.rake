require 'rgeo-shapefile'
require 'polyline_encoder'

namespace :import do
  namespace :zipcode do
    desc "Import shape files"
    task :shapefile, [:filename] => :environment do |task,args|
      puts "Truncating zipcodes table"
      Zipcode.delete_all
      puts "Importing shapes:"
      RGeo::Shapefile::Reader.open(args[:filename], :factory => Zipcode::FACTORY) do |file|
        file.each do |record|
          region_id = Region.find_by_fipscode("US#{record['STATEFP10']}").id
          zcta = record['ZCTA5CE10'].to_s
          # The record geometry is a MultiPolygon. Iterate over its parts.
          record.geometry.projection.each do |poly|
            Zipcode.create(:name => zcta, :area => poly, :region_id => region_id)
            print '.'
          end
        end
      end
      puts 'Done'
    end

    desc "Populate encoded polyline data"
    task :polyline => :environment do |task,args|
      puts "Populating encoded polylines:"
      Zipcode.find_each do |z|
        z.update_attribute(:polyline, PolylineEncoder.encode(Zipcode::FACTORY.unproject(z.area).exterior_ring))
        print '.'
      end
      puts 'Done'
    end
  end

  namespace :region do
    desc "Import shape files"
    task :shapefile, [:filename] => :environment do |task,args|
      puts 'Truncating regions table'
      #Region.delete_all
      puts 'Importing shapes:'
      RGeo::Shapefile::Reader.open(args[:filename], :factory => Region::FACTORY) do |file|
        file.each do |record|
          name = record['NAME_1']
          record.geometry.projection.each do |poly|
            polyline = PolylineEncoder.encode(Region::FACTORY.unproject(poly).exterior_ring)
            Region.create(:name => name, :polyline => polyline, :area => poly)
            print '.'
          end
        end
      end
      puts 'Done'
    end

    desc 'Update areas'
    task :update_area, [:filename] => :environment do |task,args|
      puts 'Importing shapes:'
      RGeo::Shapefile::Reader.open(args[:filename], :factory => Region::FACTORY) do |file|
        file.each do |record|
          name = record['NAME_1']
          if region = Region.find_by_name(name)
            record.geometry.projection.each do |poly|
              polyline = PolylineEncoder.encode(Region::FACTORY.unproject(poly).exterior_ring)
              region.update_attributes(:polyline => polyline, :area => poly)
              print '.'
            end
          else
            puts "Error: couldn't find region with name #{name}"
          end
        end
      end
      puts 'Done'
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
        Region.create(params)
      end
    end
  end
end
