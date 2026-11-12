class CreateParts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts do |t|
      t.string :part_num
      t.string :name
      t.string :category
      t.string :image_url

      t.timestamps
    end
  end
end
