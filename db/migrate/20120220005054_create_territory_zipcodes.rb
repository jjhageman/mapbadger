class CreateTerritoryZipcodes < ActiveRecord::Migration
  def change
    create_table :territory_zipcodes do |t|
      t.references :zipcode
      t.references :territory

      t.timestamps
    end

    add_index :territory_zipcodes, :territory_id
    add_index :territory_zipcodes, :zipcode_id
  end
end
