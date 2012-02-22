class AddAreaToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :area, :polygon, :srid => 3785
    add_index :regions, :area, :spatial => true
    rename_column :regions, :coords, :polyline
    remove_column :regions, :created_at
    remove_column :regions, :updated_at
  end
end
