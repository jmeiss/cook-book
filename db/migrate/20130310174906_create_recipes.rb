class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :preparation_time
      t.integer :roasting_time
      t.string :quantity
      t.text :url
      t.references :user, index: true

      t.timestamps
    end
  end
end
