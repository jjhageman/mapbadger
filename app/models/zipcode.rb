class Zipcode < ActiveRecord::Base
  has_many :geometries
  belongs_to :region

  def self.all_zipcodes
    @zipcodes ||= Zipcode.includes(:geometries).all
  end

  def as_json(options=nil)
    super((options || {}).merge(include: {geometries: {only: [:id, :polyline]}}))
  end
end
