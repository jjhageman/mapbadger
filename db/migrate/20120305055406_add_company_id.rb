class AddCompanyId < ActiveRecord::Migration
  def change
    add_column :opportunities, :company_id, :integer
    add_index :opportunities, :company_id
    add_column :representatives, :company_id, :integer
    add_index :representatives, :company_id
    add_column :territories, :company_id, :integer
    add_index :territories, :company_id
  end
end
