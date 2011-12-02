class CreateTerritoryRegions < ActiveRecord::Migration
  def change
    create_table :territory_regions do |t|
      t.references :territory
      t.references :region

      t.timestamps
    end

    add_index :territory_regions, :territory_id
    add_index :territory_regions, :region_id
  end
end
