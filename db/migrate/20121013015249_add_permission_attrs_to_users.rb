class AddPermissionAttrsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    add_column :users, :volunteer, :boolean
    add_column :users, :verified_volunteer, :boolean
  end
end
