class ChangeTableName < ActiveRecord::Migration[6.1]
  def change
    rename_table :products, :product_categories
  end
end
