class SetPreparationTimeAsString < ActiveRecord::Migration
  def up
    change_column :recipes, :preparation_time, :string
    change_column :recipes, :roasting_time, :string
  end

  def down
    recipes = Recipe.all
    change_column :recipes, :preparation_time, :integer
    change_column :recipes, :roasting_time, :integer
    Recipe.all.each_with_index do |recipe, index|
      recipe.update_attribute :preparation_time, recipes[index].preparation_time.to_i
      recipe.update_attribute :roasting_time, recipes[index].roasting_time.to_i
    end
  end
end
