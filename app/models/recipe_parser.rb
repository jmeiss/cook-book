require 'uri'
require 'json'
require 'net/http'

class RecipeParser

  def self.get_method_name_for_url url
    URI.parse(url).host.gsub(/\./, '_')
  end

  def self.get_www_marmiton_org_recipe url
    url_id    = url.scan(/\d+/).last
    json_obj  = RecipeParser.get_json_from_www_marmiton_org_url_id(url_id)['data']['items'][0]

    recipe = Recipe.new name: json_obj['title'],
                        preparation_time: json_obj['preparationTime'],
                        roasting_time: json_obj['cookingTime'],
                        quantity: json_obj['servings'],
                        url: url

    ingredients = RecipeParser.get_www_marmiton_org_ingredients json_obj['ingredientList']
    ingredients.each { |ingredient| recipe.ingredients << Ingredient.new(name: ingredient) }

    directions = RecipeParser.get_www_marmiton_org_directions json_obj['preparationList']
    directions.each { |direction| recipe.directions << Direction.new(name: direction) }

    images_url = RecipeParser.get_www_marmiton_org_images json_obj['pictures']
    images_url.each { |url| recipe.images << Image.new(remote_file_url: url) }

    recipe
  end

  def self.get_json_from_www_marmiton_org_url_id url_id 
    url = "http://m.marmiton.org/webservices/json.svc/GetRecipeById?SiteId=1&RecipeId=#{url_id}"
    JSON.parse Net::HTTP.get_response(URI.parse(url)).body
  end

  def self.get_www_marmiton_org_ingredients string
    string.gsub!('- ', '')

    ingredients = []
    patterns = ['<br>', "\r\n"]
    patterns.each do |pattern|
      ingredients = string.split(pattern) and break if string.include?(pattern)
    end
    ingredients.each {|ingredient| ingredient.strip!}
  end

  def self.get_www_marmiton_org_directions string
    directions = []
    patterns = ['<br><br>', " \r\n\r\n"]
    patterns.each do |pattern|
      directions = string.split(pattern) and break if string.include?(pattern)
    end
    directions.each {|direction| direction.strip!}
  end

  def self.get_www_marmiton_org_images array
    [array.last['url'] || nil]
  end

end
