class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :name
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end
  end
end
