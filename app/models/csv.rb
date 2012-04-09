class Csv < ActiveRecord::Base
  belongs_to :company
  mount_uploader :file, CsvUploader
end
