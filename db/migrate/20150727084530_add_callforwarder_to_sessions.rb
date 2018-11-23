class AddCallforwarderToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :callforwarder, :boolean
  end
end
