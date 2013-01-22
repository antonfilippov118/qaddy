class CreateEmailBanners < ActiveRecord::Migration
  def change
    create_table :email_banners do |t|
      t.text :comment
      t.boolean :active
      t.references :webstore

      t.timestamps
    end
    add_index :email_banners, :webstore_id
  end
end
