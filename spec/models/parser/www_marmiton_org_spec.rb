require 'spec_helper'

describe 'www.marmiton.org' do
  it "should return a Recipe object filled with marmiton recipe" do
    url       = 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx'
    fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21864.json')
    Parser::WwwMarmitonOrg.any_instance.stub(:get_json_from_url_id).with(any_args).and_return(File.read(fake_file))
    
    recipe  = Recipe.new  name: 'Les Timbales de Jeanne (saumon à la mousse de courgettes au micro-ondes)',
                          preparation_time: 10,
                          roasting_time: 3,
                          quantity: 'Pour 4 personnes',
                          url: 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx'

    ingredients = ["4 tranches de saumon fumé", "2 courgettes", "3 oeufs", "10 cl de crème fraîche épaisse", 
                      "aneth", "menthe", "1 gousse d'ail (petite)", "poivre, sel", "huile d'olive"]
    ingredients.each do |ingredient|
      recipe.ingredients << Ingredient.new(name: ingredient)
    end

    directions = ["Râper les courgettes.", "Les faire revenir dans de l'huile d'olive avec l'ail et les herbes. Poivrer, et saler (mais pas trop, attention au saumon fumé !). Réserver, et laisser un peu refroidir.", 
                    "Battre les oeufs et la crème en omelette.", "Mélanger l'omelette avec les courgettes, éventuellement, donner un petit coup de mixeur pour le côté \"mousse\".", 
                    "Tapisser 4 ramequins avec les tranches de saumon fumé.", "Verser le mélange omelette-courgettes dans les ramequins tapissés de saumon.", 
                    "Faire cuire au micro-ondes pendant 2 à 3 min, selon la puissance (vérifier la cuisson vous même, il n'y a que ça de vrai !)"]
    directions.each do |direction|
      recipe.directions << Direction.new(name: direction)
    end

    expected_recipe = Parser::WwwMarmitonOrg.get_recipe(url)

    expected_recipe.ingredients.first.name.should eq(ingredients.first)
    expected_recipe.ingredients.last.name.should eq(ingredients.last)
    expected_recipe.ingredients.size.should eq(9)
    expected_recipe.directions.first.name.should eq(directions.first)
    expected_recipe.directions.last.name.should eq(directions.last)
    expected_recipe.directions.size.should eq(7)
    # SHOULD BE GREEN
    # expected_recipe.should eq(recipe)
  end

  describe 'www.marmiton.org with \r\n separators' do
    it "should return an array of ingredients" do
      fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21864.json')
      Parser::WwwMarmitonOrg.any_instance.stub(:get_json_from_url_id).with(any_args).and_return(File.read(fake_file))
      fake_json = Parser::WwwMarmitonOrg.get_json_from_url_id('21864')

      ingredients = ["4 tranches de saumon fumé", "2 courgettes", "3 oeufs", "10 cl de crème fraîche épaisse", 
                      "aneth", "menthe", "1 gousse d'ail (petite)", "poivre, sel", "huile d'olive"]

      Parser::WwwMarmitonOrg.get_ingredients(fake_json['data']['items'][0]['ingredientList']).should eq(ingredients)
    end

    it "should return an array of directions" do
      fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21864.json')
      Parser::WwwMarmitonOrg.any_instance.stub(:get_json_from_url_id).with(any_args).and_return(File.read(fake_file))
      fake_json = Parser::WwwMarmitonOrg.get_json_from_url_id('21864')
      
      directions = ["Râper les courgettes.", "Les faire revenir dans de l'huile d'olive avec l'ail et les herbes. Poivrer, et saler (mais pas trop, attention au saumon fumé !). Réserver, et laisser un peu refroidir.", 
                    "Battre les oeufs et la crème en omelette.", "Mélanger l'omelette avec les courgettes, éventuellement, donner un petit coup de mixeur pour le côté \"mousse\".", 
                    "Tapisser 4 ramequins avec les tranches de saumon fumé.", "Verser le mélange omelette-courgettes dans les ramequins tapissés de saumon.", 
                    "Faire cuire au micro-ondes pendant 2 à 3 min, selon la puissance (vérifier la cuisson vous même, il n'y a que ça de vrai !)"]

      Parser::WwwMarmitonOrg.get_directions(fake_json['data']['items'][0]['preparationList']).should eq(directions)
    end
  end

  describe 'www.marmiton.org with <br> separators' do
    it "should return an array of ingredients" do
      fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21966.json')
      Parser::WwwMarmitonOrg.any_instance.stub(:get_json_from_url_id).with(any_args).and_return(File.read(fake_file))
      fake_json = Parser::WwwMarmitonOrg.get_json_from_url_id('21966')

      ingredients = ["2 kg d'épinards", "60 g de beurre", "12 sardines vidées", "3 oignons", "2 gousses d'ail", 
                      "60 g de crème fraîche épaisse", "50 g de chapelure", "3 cuillères à soupe d'huile", "sel et poivre"]

      Parser::WwwMarmitonOrg.get_ingredients(fake_json['data']['items'][0]['ingredientList']).should eq(ingredients)
    end

    it "should return an array of directions" do
      fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21966.json')
      Parser::WwwMarmitonOrg.any_instance.stub(:get_json_from_url_id).with(any_args).and_return(File.read(fake_file))
      fake_json = Parser::WwwMarmitonOrg.get_json_from_url_id('21966')
      
      directions = ["Préchauffer le four à 180°C (thermostat 6).", 
                    "Émincer les oignons et l'ail, et les faire revenir dans le beurre chaud pendant 5 minutes. Incorporer les épinards et laisser fondre doucement. Saler, poivrer.", 
                    "Lorsque toute l'eau de végétation s'est évaporée, ajouter la crème et ôter du feu.", 
                    "Mettre 1 cuillère à soupe d’épinard sur les sardines et les rouler délicatement en partant du haut vers la queue. Piquer avec un cure-dent en bois pour les maintenir roulées.", 
                    "Beurrer une terrine et y verser le reste d’épinards.", 
                    "Déposer les sardines  dans le plat, verser un filet d’huile d’olive, recouvrir de chapelure et placer au four pendant 15 minutes. Servir immédiatement."]

      Parser::WwwMarmitonOrg.get_directions(fake_json['data']['items'][0]['preparationList']).should eq(directions)
    end
  end
end
