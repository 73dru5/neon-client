class CreateApiKeys < ActiveRecord::Migration[7.2]
  def change
    create_table :api_keys, id: :uuid do |t|
      t.string :token
      t.uuid :user, null: false
      t.datetime :last_used_at

      t.timestamps
    end
    add_index :api_keys, :token
    add_foreign_key :api_keys, :users, column: :id
  end
end
