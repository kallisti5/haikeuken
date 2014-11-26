class BuildersController < ApplicationController
  before_action :set_builder, only: [:show, :edit, :update, :destroy]
  before_action :set_builder_byhost, only: [:getwork, :putwork]

  # We accept data from outside of the normal rails app
  skip_before_action :verify_authenticity_token, only: [:putwork]

  # GET /builders
  # GET /builders.json
  def index
    @builders = Builder.all
  end

  # GET /builders/1
  # GET /builders/1.json
  def show
  end

  # POST /builders/hostname/putwork 
  def putwork
    if !@builder or params[:token] != @builder['token']
      # Invalid builder or token, redirect to root
      redirect_to "/", notice: 'Invalid builder API call!'
      return
    end

    @builder.update(:lastheard => Time.now)
	build = Build.find(params[:build_id])
	build.update(:completed => Time.now, :status => (params[:result] == "true") ? "Success" : "Failure")

	redirect_to "/"
  end

  # GET /builders/hostname/getwork
  def getwork
    if !@builder or params[:token] != @builder['token']
      # Invalid builder or token, redirect to root
      redirect_to "/", notice: 'Invalid builder API call!'
      return
    end

    @builder.update(:lastheard => Time.now)

    workitems = []
    Package.joins(:recipe).where("packages.latestrev < recipes.revision").where(architecture: @builder.architecture).each do |package|

      # Limit to one workitem for now
      # Could this be done in the query?
      next if workitems.count > 0
      next if Build.where(recipe: package.recipe).where(completed: nil).count > 0

      # Schedule the build for this builder
      build = Build.create(architecture: package.architecture,
        builder: @builder, recipe: package.recipe, issued: Time.now,
		status: "Building")

      # last seen built revision is outdated
      # add work to tasks
      task = {
		:id => build[:id],
        :name => package.recipe[:name],
        :version => package.recipe[:version],
        :revision => package.recipe[:revision],
        :architecture => @builder.architecture[:name]
      }
      workitems.push(task)
    end
    
    render json: workitems
  end

  # POST /builders
  # POST /builders.json
  def create
    @builder = Builder.new(builder_params)

    respond_to do |format|
      if @builder.save
        format.html { redirect_to @builder, notice: 'Builder was successfully created.' }
        format.json { render :show, status: :created, location: @builder }
      else
        format.html { render :new }
        format.json { render json: @builder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /builders/1
  # PATCH/PUT /builders/1.json
  def update
    respond_to do |format|
      if @builder.update(builder_params)
        format.html { redirect_to @builder, notice: 'Builder was successfully updated.' }
        format.json { render :show, status: :ok, location: @builder }
      else
        format.html { render :edit }
        format.json { render json: @builder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /builders/1
  # DELETE /builders/1.json
  def destroy
    @builder.destroy
    respond_to do |format|
      format.html { redirect_to builders_url, notice: 'Builder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_builder
      @builder = Builder.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_builder_byhost
      @builder = Builder.find_by(hostname: params[:hostname])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def builder_params
      params.require(:builder).permit(:architecture_id, :hostname, :owner, :location, :lastheard, :token, :result, :build_id)
    end
end
