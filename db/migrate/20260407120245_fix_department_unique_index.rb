class FixDepartmentUniqueIndex < ActiveRecord::Migration[8.1]
  def change
    remove_index :departments, :name
    add_index :departments, [:organization_id, :name], unique: true
  end
end
