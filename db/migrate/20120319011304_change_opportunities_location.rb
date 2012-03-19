class ChangeOpportunitiesLocation < ActiveRecord::Migration
  def up
    remove_column :opportunities, :location
    add_column :opportunities, :location, :point, :srid => 3785
    add_index :opportunities, :location, :spatial => true
    add_index :geometries, :area, :spatial => true
  end

  def down
    remove_column :opportunities, :location
    add_column :opportunities, :location, :point, :geographic => true
    remove_index :opportunities, :location
    remove_index :geometries, :area
  end
end
