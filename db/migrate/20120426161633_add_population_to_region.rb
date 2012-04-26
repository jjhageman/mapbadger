class AddPopulationToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :population, :integer
    add_column :regions, :business_population, :integer
  end
end
