class CreateLeaveRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_requests do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :leave_type
      t.date :start_date
      t.date :end_date
      t.integer :status
      t.text :reason

      t.timestamps
    end
  end
end
