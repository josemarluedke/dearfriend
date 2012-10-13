class AddPermissionAttrsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, defaul: false
    add_column :users, :volunteer, :boolean, defaul: false
    add_column :users, :verified_volunteer, :boolean, defaul: false
  end
end
