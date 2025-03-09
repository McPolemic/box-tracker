class CreateBoxGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :box_groups do |t|
      t.string :display_name
      t.text :notes

      t.timestamps
    end
  end
end
