class AddRepresentativeIdToTerritory < ActiveRecord::Migration
  def change
    add_column :territories, :representative_id, :integer
    add_index :territories, :representative_id
  end
end
