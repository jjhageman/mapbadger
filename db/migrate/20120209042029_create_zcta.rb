class CreateZcta < ActiveRecord::Migration
  def change
    create_table :zcta do |t|
      t.integer :zcta
      t.polygon :region, :srid => 3785
    end

    add_index :zcta, :region, :spatial => true
  end
end
