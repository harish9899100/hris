class AddOrganizationToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_reference :employees, :organization, null: false, foreign_key: true
  end
end
