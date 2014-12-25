class NormalizeTags < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
    end

    create_table :roles do |t|
      t.string :name
    end

    create_table :addresses_products, :id => false do |t|
      t.integer :address_id, :null => false
      t.integer :product_id, :null => false
    end

    create_table :addresses_roles, :id => false do |t|
      t.integer :address_id, :null => false
      t.integer :role_id, :null => false
    end

    drop_table :taggings
    drop_table :tags
  end
end
