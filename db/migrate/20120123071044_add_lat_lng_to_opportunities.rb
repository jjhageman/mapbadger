class AddLatLngToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :lat, :float
    add_column :opportunities, :lng, :float
  end
end
