class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :image
      t.string :name
      t.string :last_name
      t.string :plan, default: "free"

      t.integer :active_seconds_limit, default: 0
      t.integer :projects_limit, default: 0
      t.integer :branches_limit, default: 0
      t.integer :max_autoscaling_limit, default: 0

      t.jsonb :auth_accounts, default: []

      t.timestamps
    end
  end
end
