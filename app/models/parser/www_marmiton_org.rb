require 'uri'
require 'json'
require 'net/http'

class Parser::WwwMarmitonOrg

  def self.get_recipe url
    url_id    = url.scan(/\d+/).last
    json_obj  = self.get_json_from_url_id(url_id)['data']['items'][0]

    recipe = Recipe.new name:             json_obj['title'],
                        preparation_time: json_obj['preparationTime'],
                        roasting_time:    json_obj['cookingTime'],
                        quantity:         json_obj['servings'],
                        url:              url

    ingredients = self.get_ingredients json_obj['ingredientList']
    ingredients.each { |ingredient| recipe.ingredients << Ingredient.new(name: ingredient) }

    directions = self.get_directions json_obj['preparationList']
    directions.each { |direction| recipe.directions << Direction.new(name: direction) }

    images_url = self.get_images json_obj['pictures']
    images_url.each { |url| recipe.images << Image.new(remote_file_url: url) }

    recipe
  end

  def self.get_json_from_url_id url_id 
    url = "http://m.marmiton.org/webservices/json.svc/GetRecipeById?SiteId=1&RecipeId=#{url_id}"
    JSON.parse Net::HTTP.get_response(URI.parse(url)).body
  end

  def self.get_ingredients string
    string.gsub!('- ', '')

    ingredients = []
    patterns    = ['<br>', "\r\n"]
    patterns.each do |pattern|
      ingredients = string.split(pattern) if string.include?(pattern)
    end
    ingredients.reject! { |ingredient| ingredient.empty? }
    ingredients.each { |ingredient| ingredient.strip! }
  end

  def self.get_directions string
    directions  = []
    patterns    = ['<br><br>', "\r\n\r\n", '<br>']
    patterns.each do |pattern|
      directions = string.split(pattern) if string.include?(pattern)
    end
    directions.reject! { |direction| direction.empty? }
    directions.each {|direction| direction.strip!}
  end

  def self.get_images array
    array.nil? ? [] : [array.last['url']]
  end

end
