require 'state'

namespace :centroid do
  desc 'Generate us centroids'
  task :generate => :environment do |task,args|
    State::NAMES.each do |state|
      r=Region.find_by_name state[0]
      if r
        p=if r.geometries.size > 1
          points = r.geometries.flat_map {|g| Geometry::FACTORY.unproject(g.area.exterior_ring).points}
          bbox_points = points.map{ |p| RGeo::Feature.cast(p, Geometry::FACTORY) }
          bbox = RGeo::Geographic::ProjectedWindow.bounding_points(bbox_points)
          bbox.center_point
        else
          p=r.geometries.first.area.centroid
          Geometry::FACTORY.unproject(p)
        end
        puts "#{state[0]}: [#{p.y}, #{p.x}]"
      else
        puts "couldn't find #{state[0]}"
      end
    end
  end
end
