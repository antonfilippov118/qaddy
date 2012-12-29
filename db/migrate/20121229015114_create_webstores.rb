class CreateWebstores < ActiveRecord::Migration
  def change
    create_table :webstores do |t|
      t.string :name
      t.string :url
      t.text :description
      t.references :user

      t.timestamps
    end
    add_index :webstores, :user_id
  end
end
