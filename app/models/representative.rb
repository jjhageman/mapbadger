require 'csv'

class Representative < ActiveRecord::Base
  has_many :territories

  def self.csv_import(data)
    CSV.parse(data) do |row|
      Representative.create :first_name => row[0], :last_name => row[1]
    end
  end
end
