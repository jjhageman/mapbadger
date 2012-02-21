class Region < ActiveRecord::Base
  has_many :zipcodes

  def self.all_regions
    @regions ||= Region.all
  end

  def as_json(options = nil)
    super((options || {}).merge(include: { zipcodes: { only: [:id, :name] } }))
  end
end
