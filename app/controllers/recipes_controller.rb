class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_recipe_byname, only: [:show_byname]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.search(params[:search]).includes(:packages).includes(:architectures).page(params[:page])
    @architectures = Architecture.all
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @architectures = Architecture.all
  end

  # GET /recipe/:query
  def show_byname
    if !@recipe
      # Invalid builder or token, redirect to root
      redirect_to "/", notice: "Package by that name not found!"
      return
    end
    redirect_to @recipe
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def set_recipe_byname
      if !params[:version]
        @recipe = Recipe.find_by(name: params[:name])
      else
        @recipe = Recipe.find_by(name: params[:name], version: params[:version])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:name, :version, :revision, :filename)
    end
end
