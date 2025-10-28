class CreateBoxImages < ActiveRecord::Migration[8.0]
  def change
    create_table :box_images do |t|
      t.references :box, null: false, foreign_key: true
      t.references :image, null: false, foreign_key: true

      t.timestamps
    end
    add_index :box_images, [ :box_id, :image_id ], unique: true
  end
end
