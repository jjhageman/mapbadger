class Representative < ActiveRecord::Base
  def self.csv_import(file)
    ActiveRecord::Base.connection.execute(<<-SQL)
      COPY representatives (first_name, last_name) 
      FROM '#{file.path}' CSV;
      SQL
  end
end
