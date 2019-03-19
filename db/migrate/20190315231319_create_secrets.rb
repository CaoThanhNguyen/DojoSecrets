class CreateSecrets < ActiveRecord::Migration[5.0]
  def change
    create_table :secrets do |t|
      t.references :user, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
