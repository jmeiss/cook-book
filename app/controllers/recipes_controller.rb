class RecipesController < ApplicationController
  
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes  = current_user.recipes
    @recipe   = Recipe.new
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    if recipe_params[:url_to_parse]
      @recipe = Recipe.build_recipe_from_url recipe_params[:url_to_parse]
      if @recipe
        @recipe.user = current_user
      else
        # return "Désolé, ce site n'est pas supporté. Merci d'ajouter la recette manuellement."
      end
    else
      @recipe = current_user.recipes.new recipe_params
    end

    respond_to do |format|
      if @recipe && @recipe.save
        format.html { redirect_to [current_user, @recipe], notice: 'Recipe was successfully created.' }
        format.json { render action: 'show', status: :created, location: @recipe }
      else
        format.html { render action: 'new' }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to [current_user, @recipe], notice: 'Recipe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to user_recipes_url(current_user) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit  :name, :preparation_time, :roasting_time, :quantity, :url, :url_to_parse,
                                      directions_attributes:  [:_destroy, :name, :position],
                                      images_attributes:      [:_destroy, :name, :file],
                                      ingredients_attributes: [:_destroy, :name]
    end
end
