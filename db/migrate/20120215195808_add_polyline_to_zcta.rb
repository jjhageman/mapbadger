class AddPolylineToZcta < ActiveRecord::Migration
  def change
    add_column :zcta, :polyline, :text
  end
end
