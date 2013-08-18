class CreateStoreSkucodes < ActiveRecord::Migration
  def change
    create_table :store_skucodes do |t|
      t.integer :sku_id, null: false
      t.string :storecode, null: false
      t.string :skucode, null: false
    end

    add_index :store_skucodes, :sku_id
  end
end
