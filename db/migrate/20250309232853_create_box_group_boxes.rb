class CreateBoxGroupBoxes < ActiveRecord::Migration[8.0]
  def change
    create_table :box_group_boxes do |t|
      t.references :box_group, null: false, foreign_key: true
      t.references :box, null: false, foreign_key: true

      t.timestamps
    end

    add_index :box_group_boxes, [:box_group_id, :box_id], unique: true
  end
end
