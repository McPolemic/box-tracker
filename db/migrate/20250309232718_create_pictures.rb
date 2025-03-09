class CreatePictures < ActiveRecord::Migration[8.0]
  def change
    create_table :pictures do |t|
      t.binary :data
      t.string :content_type

      t.timestamps
    end
  end
end
