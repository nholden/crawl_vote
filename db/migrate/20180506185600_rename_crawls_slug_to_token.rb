class RenameCrawlsSlugToToken < ActiveRecord::Migration[5.2]
  def change
    rename_column :crawls, :slug, :token
  end
end
