require 'uri'
require 'json'
require 'net/http'

class RecipeParser

  def self.get_method_name_for_url url
    URI.parse(url).host.gsub(/\./, '_')
  end

  def self.get_json_from_www_marmiton_org_url_id url_id 
    url   = "http://m.marmiton.org/webservices/json.svc/GetRecipeById?SiteId=1&RecipeId=#{url_id}"
    data  = Net::HTTP.get_response(URI.parse(url)).body
    JSON.parse data
  end

  def self.www_marmiton_org url
    url_id    = url.scan(/\d+/).last
    json_obj  = RecipeParser.get_json_from_www_marmiton_org_url_id url_id
    recipe    = json_obj['data']['items'][0]

    recipe = Recipe.new name: recipe['title'],
                        preparation_time: recipe['preparationTime'],
                        roasting_time: recipe['cookingTime'],
                        quantity: recipe['servings'],
                        url: url
    recipe
  end

  def self.get_www_marmiton_org_ingredients string
    string.gsub('- ', '').split("\r\n")
  end

  def self.get_www_marmiton_org_directions string
    return string.split('<br><br>') if string.include?('<br><br>')
    string.split(" \r\n\r\n") if string.include?(" \r\n\r\n")
  end

end