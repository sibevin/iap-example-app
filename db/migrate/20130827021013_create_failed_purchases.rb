class CreateFailedPurchases < ActiveRecord::Migration
  def change
    create_table :failed_purchases do |t|
      t.integer :user_id
      t.integer :sku_id
      t.string :store
      t.text :receipt
      t.string :transaction_val
      t.string :pinfo
      t.string :dinfo
      t.string :error_code
      t.timestamps
    end
  end
end
