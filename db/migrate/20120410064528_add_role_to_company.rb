class AddRoleToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :role, :string
  end
end
