class AddPerformanceIndexesToLegoTables < ActiveRecord::Migration[7.1]
  def change
    # Speeds up unique set and part identifier scans
    add_index :lego_sets, :set_num, unique: true unless index_exists?(:lego_sets, :set_num)
    add_index :parts, :part_num, unique: true unless index_exists?(:parts, :part_num)

    # Crucial speed fix: Optimizes the intensive "includes(:part)" join lookup matrix
    add_index :inventory_parts, :lego_set_id unless index_exists?(:inventory_parts, :lego_set_id)
    add_index :inventory_parts, :part_id unless index_exists?(:inventory_parts, :part_id)
    
    # Combined compound optimization index for checking/toggling off matching pieces
    add_index :inventory_parts, [:lego_set_id, :id], unique: true unless index_exists?(:inventory_parts, [:lego_set_id, :id])
  end
end
