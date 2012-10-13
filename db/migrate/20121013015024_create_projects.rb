class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :goal
      t.string :image_url

      t.timestamps
    end
  end
end
