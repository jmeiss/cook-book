class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :file
      t.references :recipe, index: true

      t.timestamps
    end
  end
end
