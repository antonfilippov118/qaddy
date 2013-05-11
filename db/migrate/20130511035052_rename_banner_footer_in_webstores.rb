class RenameBannerFooterInWebstores < ActiveRecord::Migration
  def change
    rename_column :webstores, :footer, :custom_email_html_footer
    rename_column :webstores, :banner_file_name, :custom_email_banner_file_name
    rename_column :webstores, :banner_content_type, :custom_email_banner_content_type
    rename_column :webstores, :banner_file_size, :custom_email_banner_file_size
    rename_column :webstores, :banner_updated_at, :custom_email_banner_updated_at
  end
end
