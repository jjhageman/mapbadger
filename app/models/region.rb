class Region < ActiveRecord::Base
  def self.all_regions
    @regions ||= Region.all
  end
end
