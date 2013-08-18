class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
    end
  end
end
