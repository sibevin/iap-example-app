class CreateInAppPurchases < ActiveRecord::Migration
  def change
    create_table :in_app_purchases do |t|
      t.integer :user_id, null: false
      t.integer :sku_id, null: false
      t.string :store, null: false
      t.string :transaction_val, null: false
      t.text :receipt, null: false
      t.string :pinfo, null: false
      t.string :dinfo, null: false
      t.string :error_code, null: false
      t.datetime :purchased_at, null: false
      t.datetime :expires_at
      t.datetime :cancelled_at
      t.datetime :refunded_at
      t.timestamps
    end
    add_index :in_app_purchases, [:store, :transaction_val]
    add_index :in_app_purchases, :user_id
  end
end
