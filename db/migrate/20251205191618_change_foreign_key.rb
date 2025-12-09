class ChangeForeignKey < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :api_keys, column: :id
    add_foreign_key :api_keys, :users, column: :user
  end
end
