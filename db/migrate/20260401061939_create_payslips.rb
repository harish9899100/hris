class CreatePayslips < ActiveRecord::Migration[8.1]
  def change
    create_table :payslips do |t|
      t.references :employee, null: false, foreign_key: true
      t.integer :month
      t.integer :year
      t.decimal :gross
      t.decimal :deductions
      t.decimal :net

      t.timestamps
    end
    add_index :payslips, [:employee_id, :month, :year], unique: true
  end
end
