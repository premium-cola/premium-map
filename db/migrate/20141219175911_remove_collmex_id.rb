class RemoveCollmexId < ActiveRecord::Migration
  def change
    remove_column :addresses, :collmex_id
  end
end
