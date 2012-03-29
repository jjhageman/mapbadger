require 'rgeo-shapefile'
require 'polyline_encoder'

namespace :import do
  namespace :nasdaq do
    desc 'Import NASDAQ companies csv file'
    task :csv, [:filename] => :environment do |task,args|
      raise "File does not exits: #{args[:filename]}" unless File.exists?(args[:filename])
      puts 'Truncating nasdaq_companies table'
      NasdaqCompany.delete_all
      puts 'Importing csv:'
    end
  end

  namespace :region do
    desc 'Populate regions table from shapefile'
    task :shapefile, [:filename] => :environment do |task,args|
      raise "File does not exits: #{args[:filename]}" unless File.exists?(args[:filename])
      puts 'Truncating regions table'
      Region.delete_all
      puts 'Processing shapes:'
      RGeo::Shapefile::Reader.open(args[:filename]) do |file|
        file.each do |record|
          name = record['NAME_1']
          fips = record['FIPS']
          #fips.prepend('US') unless fips.include? 'CA'
          Region.find_or_create_by_name(:fipscode => fips, :name => name)
        end
      end
      puts 'Done'
    end

    namespace :geometries do
      desc "Populate region geometries table from shapefile"
      task :shapefile, [:filename] => :environment do |task,args|
        raise "File does not exits: #{args[:filename]}" unless File.exists?(args[:filename])
        puts 'Processing shapes:'
        RGeo::Shapefile::Reader.open(args[:filename], :factory => Geometry::FACTORY) do |file|
          file.each do |record|
            name = record['NAME_1']
            #fips = record['FIPS']
            region_id = Region.find_by_name(name).id
            record.geometry.projection.each do |poly|
              polyline = PolylineEncoder.encode(Geometry::FACTORY.unproject(poly).exterior_ring)
              Geometry.create(:polyline => polyline, :area => poly, :region_id => region_id)
              print '.'
            end
          end
        end
        puts 'Done'
      end
    end
  end

  namespace :zipcode do
    desc "Populate zipcodes table from shapefile"
    task :shapefile, [:filename] => :environment do |task,args|
      raise "File does not exits: #{args[:filename]}" unless File.exists?(args[:filename])
      puts "Truncating zipcodes table"
      Zipcode.delete_all
      puts "Processing shapes:"
      RGeo::Shapefile::Reader.open(args[:filename]) do |file|
        file.each do |record|
          region_id = Region.find_by_fipscode(record['STATEFP10']).id
          name = record['ZCTA5CE10'].to_s
          Zipcode.find_or_create_by_name(:name => name, :region_id => region_id)
        end
      end
      puts 'Done'
    end

    namespace :geometries do
      desc "Populate zipcode geometries table from shapefile"
      task :shapefile, [:filename] => :environment do |task,args|
        raise "File does not exits: #{args[:filename]}" unless File.exists?(args[:filename])
        puts 'Processing shapes:'
        RGeo::Shapefile::Reader.open(args[:filename], :factory => Geometry::FACTORY) do |file|
          file.each do |record|
            name = record['ZCTA5CE10'].to_s
            zipcode_id = Zipcode.find_by_name(name).id
            record.geometry.projection.each do |poly|
              polyline = PolylineEncoder.encode(Geometry::FACTORY.unproject(poly).exterior_ring)
              Geometry.create(:polyline => polyline, :area => poly, :zipcode_id => zipcode_id)
              print '.'
            end
          end
        end
        puts 'Done'
      end
    end

  end

end
