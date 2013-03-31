class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :code
      t.decimal :amount
      t.boolean :active
      t.references :webstore

      t.timestamps
    end
    add_index :campaigns, :webstore_id
  end
end
