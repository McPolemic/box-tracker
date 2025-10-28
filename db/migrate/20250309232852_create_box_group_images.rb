class CreateBoxGroupImages < ActiveRecord::Migration[8.0]
  def change
    create_table :box_group_images do |t|
      t.references :box_group, null: false, foreign_key: true
      t.references :image, null: false, foreign_key: true

      t.timestamps
    end
    add_index :box_group_images, [ :box_group_id, :image_id ], unique: true
  end
end
