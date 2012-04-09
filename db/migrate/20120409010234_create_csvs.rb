class CreateCsvs < ActiveRecord::Migration
  def change
    create_table :csvs do |t|
      t.string :file
      t.references :company

      t.timestamps
    end

    add_index :csvs, :company_id
  end
end
