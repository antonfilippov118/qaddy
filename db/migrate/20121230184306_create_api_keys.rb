class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :key, null: false
      t.boolean :enabled, default: true
      t.references :user, null: false

      t.timestamps
    end
    add_index :api_keys, :user_id
  end
end
