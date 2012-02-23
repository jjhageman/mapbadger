class AddRegionIdToZcta < ActiveRecord::Migration
  def change
    add_column :zcta, :region_id, :integer
    add_index :zcta, :region_id
  end

end
