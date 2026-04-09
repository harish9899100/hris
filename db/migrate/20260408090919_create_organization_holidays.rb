class CreateOrganizationHolidays < ActiveRecord::Migration[8.1]
  def change
    create_table :organization_holidays do |t|
      t.string :name, null: false
      t.date :date, null: false
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end

    add_index :organization_holidays, [:organization_id, :date], unique: true
  end
end
