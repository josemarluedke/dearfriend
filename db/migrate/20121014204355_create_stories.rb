class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :kind, null: false
      t.references :user, null: false
      t.references :project, null: false
      t.integer :download_count

      t.timestamps
    end
    add_index :stories, :user_id
    add_index :stories, :project_id
  end
end
