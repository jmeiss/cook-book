class RecipesController < ApplicationController
  
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!

  # GET /recipes
  # GET /recipes.json
  def index
    @recipe   = Recipe.new
    @recipes  = Recipe.all
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
      @recipe = Recipe.build_recipe_form_url recipe_params[:url_to_parse]
      @recipe.user = current_user if @recipe
    else
      @recipe = current_user.recipes.new recipe_params
    end

    # raise @recipe.inspect

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
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit( :name, :preparation_time, :roasting_time, :quantity, :url, :url_to_parse, :user_id, :user,
                                      directions_attributes: ['name', 'position', '_destroy', 'id'],
                                      ingredients_attributes: ['name', '_destroy', 'id'])
    end
end
