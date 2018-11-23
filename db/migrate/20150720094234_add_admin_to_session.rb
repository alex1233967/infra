class AddAdminToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :admin, :boolean
  end
end
