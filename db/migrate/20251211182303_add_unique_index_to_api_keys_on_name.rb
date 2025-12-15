class AddUniqueIndexToApiKeysOnName < ActiveRecord::Migration[7.2]
  def change
    add_index :api_keys, :name, unique: true, name: "index_api_keys_on_name_unique"
  end
end
