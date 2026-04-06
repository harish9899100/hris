class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email
      t.string :api_key
      t.string :encrypted_password, null: false
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :api_key, unique: true
  end
end
