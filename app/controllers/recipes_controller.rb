class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.includes(:packages).includes(:architectures).all
    @architectures = Architecture.all
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @architectures = Architecture.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:name, :version, :revision, :filename)
    end
end
