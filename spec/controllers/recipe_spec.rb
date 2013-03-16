require 'spec_helper'

describe RecipesController do

  let(:user_with_no_recipe) { FactoryGirl.create :user }
  let(:user_with_recipes) { FactoryGirl.create :user_with_recipes }
  let(:supported_url_to_parse) { 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx' }
  let(:not_supported_url_to_parse) { 'https://www.google.fr/' }


  describe "GET index" do
    it "should assign recipes of current_user" do
      sign_in user_with_recipes
      get :index

      assigns(:recipes).should =~ user_with_recipes.recipes
    end
  end

  describe "POST create" do
    it "create should render new with error if domain of url_to_parse is not in SUPPORTED_DOMAINS_TO_PARSE" do
      sign_in user_with_no_recipe
      post :create, user_id: user_with_no_recipe, recipe: {url_to_parse: not_supported_url_to_parse}

      # recipe.errors[:url_to_parse].should include "Désolé mais ce site n'est pas supporté. Merci de remplir la recette manuellement."
      response.should render_template 'new'
      Recipe.count.should eq(0)
    end

    it "create should redirect to index if domain of url_to_parse is in SUPPORTED_DOMAINS_TO_PARSE" do
      fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21864.json')
      RecipeParser.any_instance.stub(:get_json_from_www_marmiton_org_url_id).with(any_args).and_return(File.read(fake_file))

      sign_in user_with_no_recipe
      post :create, user_id: user_with_no_recipe, recipe: {url_to_parse: supported_url_to_parse}

      user_with_no_recipe.recipes.last.name.should eq('Les Timbales de Jeanne (saumon à la mousse de courgettes au micro-ondes)')
      user_with_no_recipe.recipes.count.should eq(1)
    end
  end

end
