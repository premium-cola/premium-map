class AddContactToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :telephone, :string
    add_column :addresses, :web, :string
    add_column :addresses, :email, :string
  end
end
