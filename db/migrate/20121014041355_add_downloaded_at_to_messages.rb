class AddDownloadedAtToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :downloaded_at, :date
  end
end
