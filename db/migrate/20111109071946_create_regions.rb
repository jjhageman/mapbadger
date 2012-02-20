class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.string :fipscode
      t.text :coords
    end
  end
end
