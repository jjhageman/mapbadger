class AddLocationToOpportunity < ActiveRecord::Migration
  def change
    add_column :opportunities, :location, :point, :geographic => true

  end
end
