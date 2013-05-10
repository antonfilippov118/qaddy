class AddCustomEmailTextsToWebstores < ActiveRecord::Migration
  def change
    add_column :webstores, :custom_email_subject_with_discount, :string
    add_column :webstores, :custom_email_html_text_with_discount, :text
    add_column :webstores, :custom_email_subject_without_discount, :string
    add_column :webstores, :custom_email_html_text_without_discount, :text
  end
end
