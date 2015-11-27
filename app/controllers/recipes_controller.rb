class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.includes(packages: [:repo, :architecture]).search(params[:search]).page(params[:page])
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
    query = params[:id].split('-')
    if !query[1]
      @recipe = Recipe.where(name: query[0]).includes(packages: [:repo, :architecture]).order('version DESC').first
    else
      @recipe = Recipe.includes(packages: [:repo, :architecture]).find_by(name: query[0], version: query[1])
    end
    if !@recipe
      # Invalid builder or token, redirect to root
      redirect_to '/', notice: 'Package by that name not found!'
      return
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def recipe_params
    params.require(:recipe).permit(:name, :version, :revision, :filename)
  end
end
