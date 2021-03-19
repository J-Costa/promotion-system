class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :products, :code, unique: true
  end
end
