require 'spec_helper'

describe RecipeParser do

  describe 'get_method_name_for_url' do
    it "should return domain name for url" do
      ['http://www.marmiton.org/', 'http://www.marmiton.org/recettes/recette_les-timbales_21864.aspx'].each do |url|
        RecipeParser.get_method_name_for_url(url).should eq('www_marmiton_org')
      end
    end
  end

  describe 'www_marmiton_org' do
    it "should return a Recipe object filled with marmiton recipe" do
      url       = 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx'
      fake_json = Rails.root.join('spec', 'fixtures', 'm.marmiton.org-webservices-json.svc-GetRecipeById-SiteId-1-RecipeId-21864.json')
      RecipeParser.any_instance.stub(:get_json_from_www_marmition_org_url_id).with('21864').and_return(File.read(fake_json))
      
      recipe  = Recipe.new  name: 'Les Timbales de Jeanne (saumon à la mousse de courgettes au micro-ondes)',
                            preparation_time: 10,
                            roasting_time: 3,
                            quantity: 'Pour 4 personnes',
                            url: 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx'

      RecipeParser.www_marmiton_org(url).should eq(recipe)
    end
  end
end