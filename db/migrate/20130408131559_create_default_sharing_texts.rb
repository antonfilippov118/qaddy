class CreateDefaultSharingTexts < ActiveRecord::Migration
  def change
    create_table :default_sharing_texts do |t|
      t.string :text, null: false
      t.integer :use_counter, default: 0
      t.boolean :active, default: true
      t.references :webstore, null: true

      t.timestamps
    end
    add_index :default_sharing_texts, :webstore_id
  end
end
