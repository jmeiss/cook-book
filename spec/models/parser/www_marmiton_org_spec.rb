require 'spec_helper'

describe Parser::WwwMarmitonOrg do

  describe 'parse recipe' do
    let (:fake_file)    { Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21864.json') }
    let!(:mock_parser)  { Parser::WwwMarmitonOrg.any_instance.stub(:get_json_from_url_id).with(any_args).and_return(File.read(fake_file)) }
    let (:url)          { 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx' }
    let (:recipe)       { Parser::WwwMarmitonOrg.get_recipe(url) }

    subject { recipe }

    its(:name)              { should eq('Les Timbales de Jeanne (saumon à la mousse de courgettes au micro-ondes)') }
    its(:preparation_time)  { should eq('10') }
    its(:roasting_time)     { should eq('3') }
    its(:quantity)          { should eq('Pour 4 personnes') }
    its(:url)               { should eq('http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx') }
  end

  context 'with \r\n separators' do
    let (:fake_file)    { Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21864.json') }
    let!(:mock_parser)  { Parser::WwwMarmitonOrg.any_instance.stub(:get_json_from_url_id).with(any_args).and_return(File.read(fake_file)) }
    let (:json)         { Parser::WwwMarmitonOrg.get_json_from_url_id('21864') }

    describe 'parse ingredients' do
      let (:ingredients)  { ["4 tranches de saumon fumé", "2 courgettes", "3 oeufs", "10 cl de crème fraîche épaisse", 
                              "aneth", "menthe", "1 gousse d'ail (petite)", "poivre, sel", "huile d'olive"] }

      subject { Parser::WwwMarmitonOrg.get_ingredients(json['data']['items'][0]['ingredientList']) }

      it           { should eq(ingredients) }
      its(:size)   { should eq(ingredients.count) }
      its('first') { should eq(ingredients.first) }
      its('last')  { should eq(ingredients.last) }
    end

    describe 'parse directions' do
      let (:directions) { ["Râper les courgettes.", "Les faire revenir dans de l'huile d'olive avec l'ail et les herbes. Poivrer, et saler (mais pas trop, attention au saumon fumé !). Réserver, et laisser un peu refroidir.", 
                            "Battre les oeufs et la crème en omelette.", "Mélanger l'omelette avec les courgettes, éventuellement, donner un petit coup de mixeur pour le côté \"mousse\".", 
                            "Tapisser 4 ramequins avec les tranches de saumon fumé.", "Verser le mélange omelette-courgettes dans les ramequins tapissés de saumon.", 
                            "Faire cuire au micro-ondes pendant 2 à 3 min, selon la puissance (vérifier la cuisson vous même, il n'y a que ça de vrai !)"] }
      
      subject { Parser::WwwMarmitonOrg.get_directions(json['data']['items'][0]['preparationList']) }

      it           { should eq(directions) }
      its(:size)   { should eq(directions.count) }
      its('first') { should eq(directions.first) }
      its('last')  { should eq(directions.last) }
    end
  end

  context 'with <br> separators' do
    let (:fake_file)    { Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21966.json') }
    let!(:mock_parser)  { Parser::WwwMarmitonOrg.any_instance.stub(:get_json_from_url_id).with(any_args).and_return(File.read(fake_file)) }
    let (:json)         { Parser::WwwMarmitonOrg.get_json_from_url_id('21966') }

    describe 'parse ingredients' do
      let (:ingredients)  { ["2 kg d'épinards", "60 g de beurre", "12 sardines vidées", "3 oignons", "2 gousses d'ail", 
                              "60 g de crème fraîche épaisse", "50 g de chapelure", "3 cuillères à soupe d'huile", "sel et poivre"] }

      subject { Parser::WwwMarmitonOrg.get_ingredients(json['data']['items'][0]['ingredientList']) }

      it           { should eq(ingredients) }
      its(:size)   { should eq(ingredients.count) }
      its('first') { should eq(ingredients.first) }
      its('last')  { should eq(ingredients.last) }
    end

    describe 'parse directions' do
      let (:directions) { ["Préchauffer le four à 180°C (thermostat 6).", 
                            "Émincer les oignons et l'ail, et les faire revenir dans le beurre chaud pendant 5 minutes. Incorporer les épinards et laisser fondre doucement. Saler, poivrer.", 
                            "Lorsque toute l'eau de végétation s'est évaporée, ajouter la crème et ôter du feu.", 
                            "Mettre 1 cuillère à soupe d’épinard sur les sardines et les rouler délicatement en partant du haut vers la queue. Piquer avec un cure-dent en bois pour les maintenir roulées.", 
                            "Beurrer une terrine et y verser le reste d’épinards.", 
                            "Déposer les sardines  dans le plat, verser un filet d’huile d’olive, recouvrir de chapelure et placer au four pendant 15 minutes. Servir immédiatement."] }
      
      subject { Parser::WwwMarmitonOrg.get_directions(json['data']['items'][0]['preparationList']) }

      it           { should eq(directions) }
      its(:size)   { should eq(directions.count) }
      its('first') { should eq(directions.first) }
      its('last')  { should eq(directions.last) }
    end
  end

end
