require 'rgeo-shapefile'
require 'polyline_encoder'

MAX_SIZE = 500
MAX_DEPTH = 12

namespace :import do
  desc "Import shape files"
  task :shapefiles, [:filename] => :environment do |task,args|
    puts "Importing shapes:"
    RGeo::Shapefile::Reader.open(args[:filename], :factory => Zipcode::FACTORY) do |file|
      file.each do |record|
        zcta = record['ZCTA5CE10'].to_s
        # The record geometry is a MultiPolygon. Iterate
        # over its parts.
        record.geometry.projection.each do |poly|
          Zipcode.create(:name => zcta, :region => poly)
          print '.'
        end
      end
    end
    #smf = RGeo::Geographic.simple_mercator_factory
    #RGeo::Shapefile::Reader.open(args[:filename], :factory => smf) do |file|
      #file.each do |record|
        ## For each MultiPolygon, analyze it and add to the database
        #handle_geometry(0, record.geometry.projection, record['ZCTA5CE10'].to_i)
      #end
    #end
    puts 'Done'
  end

  desc "Populate encoded polyline data"
  task :polyline => :environment do |task,args|
    puts "Populating encoded polylines:"
    Zipcode.find_each do |z|
      z.update_attribute(:polyline, PolylineEncoder.encode(Zipcode::FACTORY.unproject(z.region).exterior_ring))
      print '.'
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
      # puts params
      Region.create(params)
    end
  end
end

# Handle a geometry of any type
def handle_geometry(depth, geom, zcta)
  case geom
  when ::RGeo::Feature::Polygon
    handle_polygon(depth, geom, zcta)
  when ::RGeo::Feature::MultiPolygon
    geom.each do |polygon|
      handle_polygon(depth, polygon, zcta)
    end
  end
end

# Handle a polygon
def handle_polygon(depth, polygon, zcta)
  # Check the number of sides. We'll combine the number of sides for
  # the "outer edge" and any "holes" that the polygon might have.
  # A polygon boundary consists of a LineString that is closed, so
  # the first and last points are the same. Therefore, to count the
  # sides, count the number of vertices and subtract 1.
  sides = polygon.exterior_ring.num_points - 1
  polygon.interior_rings.each{ |ring| sides += ring.num_points - 1 }
  if depth >= MAX_DEPTH || sides <= MAX_SIZE
    # The polygon is small enough, or we recursed as far as we're
    # willing. Just add the polygon.
    Zipcode.create(:name => zcta, :region => polygon)#, :polyline => polyline)
    print '.'
  else
    # Split the polygon 4-to-1 and recurse
    depth = depth + 1
    # Find the bounding box for the polygon
    envelope = polygon.envelope.exterior_ring
    p1 = envelope.point_n(0)
    p2 = envelope.point_n(2)
    min_x = p1.x
    max_x = p2.x
    min_x, max_x = max_x, min_x if min_x > max_x
    min_y = p1.y
    max_y = p2.y
    min_y, max_y = max_y, min_y if min_y > max_y
    # dx and dy are the size of the bounding box.
    # cx and cy are the center point.
    dx = max_x - min_x
    dy = max_y - min_y
    cx = (min_x + max_x) * 0.5
    cy = (min_y + max_y) * 0.5
    # Check the aspect ratio of the bounding box. If it's very wide
    # or very tall, then only split in half. Otherwise, split in 4.
    if dy > dx * 2
      # The bounding box is tall, so split in half
      handle_quadrant(depth, polygon, min_x, min_y, max_x, cy, zcta)
      handle_quadrant(depth, polygon, min_x, cy, max_x, max_y, zcta)
    elsif dx > dy * 2
      # The bounding box is wide, so split in half
      handle_quadrant(depth, polygon, min_x, min_y, cx, max_y, zcta)
      handle_quadrant(depth, polygon, cx, min_y, max_x, max_y, zcta)
    else
      # The bounding box is close to square so split in four
      handle_quadrant(depth, polygon, min_x, min_y, cx, cy, zcta)
      handle_quadrant(depth, polygon, cx, min_y, max_x, cy, zcta)
      handle_quadrant(depth, polygon, min_x, cy, cx, max_y, zcta)
      handle_quadrant(depth, polygon, cx, cy, max_x, max_y, zcta)
    end
  end
end

# Take a polygon and a box. Run the algorithm on the part of the
# polygon that falls within the box.
def handle_quadrant(depth, polygon, min_x, min_y, max_x, max_y, zcta)
  # We do this by creating a rectangle for the box, and computing
  # the intersection with the input polygon. The result could be a
  # polygon, a MultiPolygon, or an empty geometry.
  box = Zipcode::FACTORY.polygon(Zipcode::FACTORY.linear_ring([
    Zipcode::FACTORY.point(min_x, min_y),
    Zipcode::FACTORY.point(min_x, max_y),
    Zipcode::FACTORY.point(max_x, max_y),
    Zipcode::FACTORY.point(max_x, min_y)]))
  puts "Non-empty quad: zcta=#{zcta}, poly class=#{polygon.class}" unless polygon.intersection(box).is_empty?
  handle_geometry(depth, polygon.intersection(box), zcta)
end
