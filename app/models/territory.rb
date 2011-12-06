class Territory < ActiveRecord::Base
  has_and_belongs_to_many :regions
  accepts_nested_attributes_for :regions, :allow_destroy => true
end
