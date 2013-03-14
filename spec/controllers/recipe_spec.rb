require 'spec_helper'

describe RecipesController do
  before do
    @user = create :user
    sign_in @user
  end

  it "create should render new with error if domain of url_to_parse is not in SUPPORTED_DOMAINS_TO_PARSE" do
    post :create, user_id: @user, recipe: {url_to_parse: 'https://www.google.fr/'}

    # recipe.errors[:url_to_parse].should include "Désolé mais ce site n'est pas supporté. Merci de remplir la recette manuellement."
    response.should render_template 'new'
    Recipe.count.should eq(0)
  end

  it "create should redirect to index if domain of url_to_parse is in SUPPORTED_DOMAINS_TO_PARSE" do
    url       = 'http://www.marmiton.org/recettes/recette_les-timbales-de-jeanne-saumon-a-la-mousse-de-courgettes-au-micro-ondes_21864.aspx'
    fake_file = Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21864.json')
    RecipeParser.any_instance.stub(:get_json_from_www_marmiton_org_url_id).with(any_args).and_return(File.read(fake_file))

    post :create, user_id: @user, recipe: {url_to_parse: url}

    Recipe.last.name.should eq('Les Timbales de Jeanne (saumon à la mousse de courgettes au micro-ondes)')
    @user.recipes.count.should eq(1)
  end
end
