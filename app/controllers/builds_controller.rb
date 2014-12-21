class BuildsController < ApplicationController
  before_action :set_build, only: [:show, :edit, :update, :destroy]

  # GET /builds
  # GET /builds.json
  def index
    @builds = Build.all.order(issued: :desc)
  end

  # GET /builds/1
  # GET /builds/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_build
      @build = Build.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_params
      params.require(:build).permit(:architecture_id, :builder_id, :recipe_id, :issued, :completed, :result)
    end
end
