class CreateImportJobs < ActiveRecord::Migration
  def change
    create_table :import_jobs do |t|
      t.string :filename
      t.boolean :submitted
      t.datetime :last_process_date
      t.text :last_process_message
      t.references :webstore

      t.timestamps
    end
    add_index :import_jobs, :webstore_id
  end
end
