class AddAllowedPhonesToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :allowed_phones, :string
  end
end
