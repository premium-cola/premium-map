class AddCollmexIdToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :collmex_id, :integer
    add_index :addresses, :collmex_id
  end
end
