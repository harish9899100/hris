class CreatePositions < ActiveRecord::Migration[8.1]
  def change
    create_table :positions do |t|
      t.string :title
      t.references :department, null: false, foreign_key: true
      t.integer :employment_type
      t.decimal :base_salary

      t.timestamps
    end
    add_index :positions, [:department_id, :title], unique: true
  end
end
