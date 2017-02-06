class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :article, foreign_key: true
      t.references :cart, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
