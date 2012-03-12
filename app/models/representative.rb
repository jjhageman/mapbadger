require 'csv'

class Representative < ActiveRecord::Base
  has_many :territories
  belongs_to :company

  def self.csv_import(data, company)
    CSV.parse(data) do |row|
      company.representatives.create :first_name => row[0], :last_name => row[1]
    end
  end
end
