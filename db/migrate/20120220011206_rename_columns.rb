class RenameColumns < ActiveRecord::Migration
  def change
    rename_column :zcta, :zcta, :name
    rename_table :zcta, :zipcodes
  end
end
