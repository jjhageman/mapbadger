class CreateNasdaqCompanies < ActiveRecord::Migration
  def change
    create_table :nasdaq_companies do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zipcode
      t.float :lat
      t.float :lng
      t.point :location, :srid => 3785
    end
    add_index :nasdaq_companies, :location
  end
end
