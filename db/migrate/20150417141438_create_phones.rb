class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.integer :phone_number
      t.string :name

      t.timestamps
    end
  end
end
