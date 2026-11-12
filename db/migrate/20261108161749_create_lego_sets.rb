class CreateLegoSets < ActiveRecord::Migration[7.1]
  def change
    create_table :lego_sets do |t|
      t.string :set_num
      t.string :name
      t.integer :year
      t.integer :total_parts
      t.string :image_url

      t.timestamps
    end
  end
end
