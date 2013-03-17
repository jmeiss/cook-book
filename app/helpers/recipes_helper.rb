module RecipesHelper

  def recipe_cover recipe
    recipe.images.count.zero? ? image_path('no-photo.png') : recipe.images.last.file.url
  end

end
