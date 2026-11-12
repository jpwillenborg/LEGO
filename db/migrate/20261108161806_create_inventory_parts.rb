class CreateInventoryParts < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_parts do |t|
      t.references :lego_set, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.integer :quantity
      t.integer :loose_count

      t.timestamps
    end
  end
end
