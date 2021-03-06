class ProgressionsController < ApplicationController
  before_action :set_progression, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  require 'csv'
  # GET /progressions
  # GET /progressions.json

  def index

    @progressions = Progression.all

    respond_to do |format|
      format.html
      format.csv { send_data @progressions.to_csv } #render text: @records.to_csv }
    end
  end

  def import
    if current_user.profile.title == "admin" or current_user.profile.title == "master"
      Progression.import(params[:file])
      redirect_to progressions_path, notice: "Records Imported"
    else
      redirect_to progressions_path, notice: "No Records Imported; You are not Admin."
    end
  end

  # GET /progressions/1/edit
  def edit
    if current_user.profile.title == "admin" or current_user.profile.title == "master"
    else
      redirect_to root_path, notice: 'Access Denied; you are not Admin.'
    end
  end

  # POST /progressions
  # POST /progressions.json
  def create
    if current_user.profile.title == "admin" or current_user.profile.title == "master"
      @progression = Progression.new(progression_params)

      respond_to do |format|
        if @progression.save
          format.html { redirect_to phases_path, notice: 'Progression was successfully created.' }
          format.json { render :show, status: :created, location: @progression }
        else
          format.html { render :new }
          format.json { render json: @progression.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: 'Nothing created, you are not Admin.'
    end
  end

  # PATCH/PUT /progressions/1
  # PATCH/PUT /progressions/1.json
  def update
    if current_user.profile.title == "admin" or current_user.profile.title == "master"
      respond_to do |format|
        if @progression.update(progression_params)
          format.html { redirect_to phases_path, notice: 'Progression was successfully updated.' }
          format.json { render :show, status: :ok, location: @progression }
        else
          format.html { render :edit }
          format.json { render json: @progression.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: 'Nothing updated, you are not Admin.'
    end
  end

  # DELETE /progressions/1
  # DELETE /progressions/1.json
  def destroy
    if current_user.profile.title == "admin" or current_user.profile.title == "master"
      @progressions.steps.destroy_all
      @progression.destroy
      respond_to do |format|
        format.html { redirect_to phases_path, notice: 'Progression was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: 'Nothing deleted, you are not Admin.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_progression
      @progression = Progression.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def progression_params
      params.require(:progression).permit(:name, :phase_id)
    end
end
