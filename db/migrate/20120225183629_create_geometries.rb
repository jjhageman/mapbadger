class CreateGeometries < ActiveRecord::Migration
  def up
    create_table :geometries do |t|
      t.text :polyline
      t.polygon :area, :srid => 3785
      t.references :region
      t.references :zipcode
    end

    add_index :geometries, :region_id
    add_index :geometries, :zipcode_id
    remove_column :regions, :polyline
    remove_column :regions, :area
    remove_column :zipcodes, :polyline
    remove_column :zipcodes, :area
  end

  def down
    drop_table :geometries
    add_column :regions, :polyline, :text
    add_column :regions, :area, :polygon, :srid => 3785
    add_column :zipcodes, :polyline, :text
    add_column :zipcodes, :area, :polygon, :srid => 3785
  end
end
