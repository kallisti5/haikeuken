class LintsController < ApplicationController
  before_action :set_lint, only: [:show, :edit, :update, :destroy]

  # GET /lints
  # GET /lints.json
  def index
    @lints = Lint.all
  end

  # GET /lints/1
  # GET /lints/1.json
  def show
  end

  # GET /lints/new
  def new
    @lint = Lint.new
  end

  # GET /lints/1/edit
  def edit
  end

  # POST /lints
  # POST /lints.json
  def create
    @lint = Lint.new(lint_params)

    respond_to do |format|
      if @lint.save
        format.html { redirect_to @lint, notice: 'Lint was successfully created.' }
        format.json { render :show, status: :created, location: @lint }
      else
        format.html { render :new }
        format.json { render json: @lint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lints/1
  # PATCH/PUT /lints/1.json
  def update
    respond_to do |format|
      if @lint.update(lint_params)
        format.html { redirect_to @lint, notice: 'Lint was successfully updated.' }
        format.json { render :show, status: :ok, location: @lint }
      else
        format.html { render :edit }
        format.json { render json: @lint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lints/1
  # DELETE /lints/1.json
  def destroy
    @lint.destroy
    respond_to do |format|
      format.html { redirect_to lints_url, notice: 'Lint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lint
      @lint = Lint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lint_params
      params.require(:lint).permit(:clean, :result)
    end
end
