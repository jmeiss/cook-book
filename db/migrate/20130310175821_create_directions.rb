class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.text :name
      t.integer :position
      t.references :recipe, index: true

      t.timestamps
    end
  end
end
