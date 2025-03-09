class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :display_name
      t.text :notes

      t.timestamps
    end
  end
end
