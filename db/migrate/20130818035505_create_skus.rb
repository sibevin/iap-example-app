class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.integer :item_id, null: false
      t.string :name, null: false
      t.string :skucode, null: false
      t.integer :price, null: false
      t.integer :amount, null: false, default: 1
      t.boolean :onshelf, null: false, default: false
      t.timestamps
    end
    add_index :skus, :skucode
    add_index :skus, :item_id
  end
end
