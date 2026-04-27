class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :employee_id
      t.date :date_of_joining
      t.integer :employment_status
      t.decimal :salary
      t.string :phone
      t.references :organization, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.references :position, null: false, foreign_key: true

      t.timestamps
    end
    add_index :employees, :email, unique: true
    add_index :employees, :employee_id, unique: true
    add_index :employees, :employment_status
  end
end
