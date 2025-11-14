class CreateAuthTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :auth_tokens do |t|
      t.string :token

      t.timestamps
    end
    add_index :auth_tokens, :token, unique: true
  end
end
