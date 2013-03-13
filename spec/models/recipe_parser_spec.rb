require 'spec_helper'

describe RecipeParser do

  describe 'get_method_name_for_url' do
    it "should return domain name for url" do
      ['http://www.marmiton.org/', 'http://www.marmiton.org/recettes/recette_les-timbales_21864.aspx'].each do |url|
        RecipeParser.get_method_name_for_url(url).should eq('www_marmiton_org')
      end
    end
  end

  describe 'www.marmiton.org' do
    it "should return a Recipe object filled with marmiton recipe" do
      url       = 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx'
      fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org-webservices-json.svc-GetRecipeById-SiteId-1-RecipeId-21864.json')
      RecipeParser.any_instance.stub(:get_json_from_www_marmiton_org_url_id).with('21864').and_return(File.read(fake_file))
      
      recipe  = Recipe.new  name: 'Les Timbales de Jeanne (saumon à la mousse de courgettes au micro-ondes)',
                            preparation_time: 10,
                            roasting_time: 3,
                            quantity: 'Pour 4 personnes',
                            url: 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx'

      RecipeParser.www_marmiton_org(url).should eq(recipe)
    end

    it "should return an array of ingredients" do
      url       = 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx'
      fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org-webservices-json.svc-GetRecipeById-SiteId-1-RecipeId-21864.json')
      RecipeParser.any_instance.stub(:get_json_from_www_marmiton_org_url_id).with('21864').and_return(File.read(fake_file))
      fake_json = RecipeParser.get_json_from_www_marmiton_org_url_id('21864')

      ingredients = ["4 tranches de saumon fumé", "2 courgettes", "3 oeufs", "10 cl de crème fraîche épaisse", 
                      "aneth", "menthe", "1 gousse d'ail (petite)", "poivre, sel", "huile d'olive"]

      RecipeParser.get_www_marmiton_org_ingredients(fake_json['data']['items'][0]['ingredientList']).should eq(ingredients)
    end

    it "should return an array of directions" do
      url       = 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx'
      fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org-webservices-json.svc-GetRecipeById-SiteId-1-RecipeId-21864.json')
      RecipeParser.any_instance.stub(:get_json_from_www_marmiton_org_url_id).with('21864').and_return(File.read(fake_file))
      fake_json = RecipeParser.get_json_from_www_marmiton_org_url_id('21864')
      
      directions = ["Râper les courgettes.", "Les faire revenir dans de l'huile d'olive avec l'ail et les herbes. Poivrer, et saler (mais pas trop, attention au saumon fumé !). Réserver, et laisser un peu refroidir.", 
                    "Battre les oeufs et la crème en omelette.", "Mélanger l'omelette avec les courgettes, éventuellement, donner un petit coup de mixeur pour le côté \"mousse\".", 
                    "Tapisser 4 ramequins avec les tranches de saumon fumé.", "Verser le mélange omelette-courgettes dans les ramequins tapissés de saumon.", 
                    "Faire cuire au micro-ondes pendant 2 à 3 min, selon la puissance (vérifier la cuisson vous même, il n'y a que ça de vrai !)"]

      RecipeParser.get_www_marmiton_org_directions(fake_json['data']['items'][0]['preparationList']).should eq(directions)
    end
  end
end