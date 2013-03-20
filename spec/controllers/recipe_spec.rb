require 'spec_helper'

describe RecipesController do

  describe 'GET index' do
    subject { assigns(:recipes) }

    context 'when not signed in' do
      let!(:action) { get :index }

      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      let!(:current_user) { login_user FactoryGirl.create :user_with_recipes }
      let!(:other_user)   { FactoryGirl.create :user_with_recipes }
      let!(:action)       { get :index }

      context 'with one user' do
        it { should =~ current_user.recipes }
      end

      context 'with two users' do
        it { should =~ current_user.recipes }
        it { should_not =~ other_user.recipes }
      end
    end
  end

  describe 'POST create' do
    context 'when not signed in' do
      let!(:action) { post :create, user_id: 42, recipe: {} }

      it { should redirect_to new_user_session_path }
    end

    context 'when signed in' do
      let!(:current_user) { login_user FactoryGirl.create :user_with_recipes }

      context 'with url to parse is not supported' do
        let (:not_supported_url)  { 'https://www.google.fr/' }
        let (:action)             { post :create, user_id: current_user, recipe: {url_to_parse: not_supported_url} }

        it { expect{action}.to change(Recipe, :count).by(0) }

        context 'when was created' do
          let (:error_message)  { "Ce site n'est pas encore supporté. Merci d'ajouter cette recette manuellement." }
          let!(:create)         { action }
          subject               { assigns(:recipe) }
          
          it { should render_template 'new' }
          it { flash[:error].should == error_message }
          its(:user)  { should == current_user }
          its(:url)   { should == not_supported_url }
        end
      end

      context 'with url to parse is supported' do
        let (:fake_file)      { Rails.root.join('spec', 'fixtures', 'm.marmiton.org', '21864.json') }
        let!(:mock_parser)    { Parser::WwwMarmitonOrg.any_instance.stub(:get_json_from_url_id).with(any_args).and_return(File.read(fake_file)) }
        let (:supported_url)  { 'http://www.marmiton.org/recettes/recette_les-timbales_21864.aspx' }
        let (:action)         { post :create, user_id: current_user, recipe: {url_to_parse: supported_url} }

        it { expect{action}.to change(Recipe, :count).by(1) }

        context 'when was created' do
          let!(:create) { action }
          let (:recipe) { assigns(:recipe) }
          subject       { recipe }

          it { should redirect_to user_recipe_path(current_user, recipe) }
          its(:user)  { should == current_user }
          its(:name)  { should == 'Les Timbales de Jeanne (saumon à la mousse de courgettes au micro-ondes)' }
          its(:url)   { should == supported_url }
        end
      end
    end
  end

end
