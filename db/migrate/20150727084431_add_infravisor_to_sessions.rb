class AddInfravisorToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :infravisor, :boolean
  end
end
