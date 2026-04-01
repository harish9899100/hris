class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
