class Opportunity < ActiveRecord::Base
  def self.csv_geo_import(file)

  end

  def self.csv_import(file)
    ActiveRecord::Base.connection.execute(<<-SQL)
      COPY opportunities (name, address1, city, state, zipcode) 
      FROM '#{file.path}' CSV;
      SQL
  end

  def latitude
    (self.location ||= Point.new).y
  end
 
  def latitude=(value)
    (self.location ||= Point.new).y = value
  end
 
  def longitude
    (self.location ||= Point.new).x
  end
 
  def longitude=(value)
    (self.location ||= Point.new).x = value
  end
end
