class CreateSignupBeta < ActiveRecord::Migration
  def change
    create_table :signup_beta do |t|
      t.string :company
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :url
      t.string :ip_address

      t.timestamps
    end
  end
end
