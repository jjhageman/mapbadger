require 'rgeo-shapefile'
require 'polyline_encoder'

namespace :import do
  namespace :region_attributes do
    desc 'Populate a new attribute in the regions table'
    task :csv, [:filename, :attribute] => :environment do |task,args|
      raise "File does not exits: #{args[:filename]}" unless File.exists?(args[:filename])
      puts 'Importing csv:'

      CSV.foreach args[:filename], :headers => true, :header_converters => :downcase do |row|
        region = Region.find_by_name(row['name'])
        if region
          region.update_attribute(args[:attribute], row[args[:attribute]].gsub(/[^\d\.]/, '').to_i)
          puts "#{region.name} updated with #{region[args[:attribute]]}"
        else
          puts "* Could not find region with name #{row['name']}"
        end
      end
      puts "Done."
    end
  end

  namespace :nasdaq do
    desc 'Import NASDAQ companies csv file'
    task :csv, [:filename] => :environment do |task,args|
      raise "File does not exits: #{args[:filename]}" unless File.exists?(args[:filename])
      puts 'Truncating nasdaq_companies table'
      NasdaqCompany.delete_all
      puts 'Importing csv:'
      CSV.foreach args[:filename], :headers => true, :header_converters => :downcase do |row|
        co = NasdaqCompany.new(:name => row['name'],
          :address1 => row['address'],
          :city => row['city'],
          :state => row['state'],
          :zipcode => row['zipcode'],
          :lat => row['latitude'],
          :lng => row['longitude'])

        co.location =  NasdaqCompany::FACTORY.point(co.lng,co.lat) if co.lng && co.lat
        co.save
        print '.'
      end
      puts 'Done'
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
