class AddBranchToPhone < ActiveRecord::Migration
  def change
    add_column :phones, :branch, :integer
  end
end
