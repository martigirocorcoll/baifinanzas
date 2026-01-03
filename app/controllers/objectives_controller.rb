class ObjectivesController < ApplicationController
  before_action :set_objective, only: %i[ show edit update destroy ]

  # GET /objectives or /objectives.json
  def index
    @objectives = Objective.all
  end

  # GET /objectives/1 or /objectives/1.json
  def show
  end

  # GET /objectives/new
  def new
    @objective = Objective.new
  end

  # GET /objectives/1/edit
  def edit
  end

  # POST /objectives or /objectives.json
  def create
    # Extraer parámetros de fecha antes de crear el objetivo
    objective_attrs = objective_params.except(:target_date_month, :target_date_year)
    
    # Convertir mes y año en fecha si están presentes
    if params[:objective][:target_date_month].present? && params[:objective][:target_date_year].present?
      month = params[:objective][:target_date_month].to_i
      year = params[:objective][:target_date_year].to_i
      objective_attrs[:target_date] = Date.new(year, month, 1).end_of_month
    end
    
    @objective = Objective.new(objective_attrs)

    respond_to do |format|
      if @objective.save
        format.html { redirect_to dashboard_index_path(show_objective: @objective.id), notice: t('controllers.objectives.created') }
        format.json { render :show, status: :created, location: @objective }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /objectives/1 or /objectives/1.json
  def update
    # Extraer parámetros de fecha antes de actualizar el objetivo
    objective_attrs = objective_params.except(:target_date_month, :target_date_year)

    # Convertir mes y año en fecha si están presentes
    if params[:objective][:target_date_month].present? && params[:objective][:target_date_year].present?
      month = params[:objective][:target_date_month].to_i
      year = params[:objective][:target_date_year].to_i
      objective_attrs[:target_date] = Date.new(year, month, 1).end_of_month
    end

    respond_to do |format|
      if @objective.update(objective_attrs)
        format.html { redirect_to dashboard_index_path(show_objective: @objective.id), notice: t('controllers.objectives.updated') }
        format.json { render :show, status: :ok, location: @objective }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /objectives/1 or /objectives/1.json
  def destroy
    @objective.destroy!

    respond_to do |format|
      format.html { redirect_to dashboard_index_path, status: :see_other, notice: t('controllers.objectives.deleted') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_objective
      @objective = Objective.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def objective_params
      params.require(:objective).permit(:user_id, :title, :description, :target_amount, :target_date, :target_date_month, :target_date_year)
    end
end
