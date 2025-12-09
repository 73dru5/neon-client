class DropOldApiKeysTable < ActiveRecord::Migration[7.2]
  def up
    # If you have any dependent indexes or foreign keys (unlikely right now), drop them first
    drop_table :api_keys, if_exists: true
  end

  def down
    # Optional: recreate the table exactly as it was before (useful for rollback)
    create_table :api_keys do |t|
      t.string :key
      t.string :name
      t.string :created_by
      t.timestamps
    end

    # Re-add any indexes you had before (e.g. unique index on key)
    add_index :api_keys, :key, unique: true if index_exists?(:api_keys, :key)
  end
end
