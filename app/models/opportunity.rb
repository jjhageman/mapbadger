class Opportunity < ActiveRecord::Base
  def self.csv_import(file)
    ActiveRecord::Base.connection.execute(<<-SQL)
      COPY opportunities (name, address1, city, state, zipcode) 
      FROM '#{file.path}' CSV;
      SQL
  end
end
