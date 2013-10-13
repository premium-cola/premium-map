class CreateAddress < ActiveRecord::Migration
  def change
    create_table(:addresses) do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :street
      t.string :zipcode
      t.string :city
      t.string :country
      t.string :comment
      t.float  :latitude
      t.float  :longitude
      t.timestamps
    end
  end
end
