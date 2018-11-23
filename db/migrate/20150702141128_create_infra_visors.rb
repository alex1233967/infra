class CreateInfraVisors < ActiveRecord::Migration
  def change
    create_table :infra_visors do |t|

      t.timestamps
    end
  end
end
