class CreateTerritoryRegions < ActiveRecord::Migration
  def change
    create_table :territories_regions, :id => false do |t|
      t.references :region
      t.references :territory

      t.timestamps
    end

    add_index :territories_regions, [:region_id, :territory_id]
    add_index :territories_regions, [:territory_id, :region_id]
  end
end
