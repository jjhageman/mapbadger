class Region < ActiveRecord::Base
  has_many :zipcodes

  def self.all_regions
    @regions ||= Region.all
  end
end
