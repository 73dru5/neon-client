class CreateApiKeysAgain < ActiveRecord::Migration[7.2]
  def change
    create_table :api_keys do |t|
      t.string :key, null: false
      t.string :name
      t.string :created_by, null: false, default: "user"

      t.timestamps
    end
    add_index :api_keys, :key, unique: true
  end
end
