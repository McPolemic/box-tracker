class CreateBoxes < ActiveRecord::Migration[8.0]
  def change
    create_table :boxes do |t|
      t.string :display_name
      t.text :contents

      t.timestamps
    end
  end
end
