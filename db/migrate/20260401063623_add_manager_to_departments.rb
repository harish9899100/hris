class AddManagerToDepartments < ActiveRecord::Migration[8.1]
  def change
    add_column :departments, :manager_id, :bigint
    add_foreign_key :departments, :employees, column: :manager_id
    add_index :departments, :manager_id
  end
end
