class PygsController < ApplicationController
  before_action :set_pyg, only: %i[ show edit update destroy ]

  # GET /pygs or /pygs.json
  def index
    @pygs = Pyg.all
  end

  # GET /pygs/1 or /pygs/1.json
  def show
  end

  # GET /pygs/new
  def new
    @pyg = Pyg.new
  end

  # GET /pygs/1/edit
  def edit
  end

  # POST /pygs or /pygs.json
  def create
    @pyg = Pyg.new(pyg_params)

    respond_to do |format|
      if @pyg.save
        format.html { redirect_to @pyg, notice: "Pyg was successfully created." }
        format.json { render :show, status: :created, location: @pyg }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pyg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pygs/1 or /pygs/1.json
  def update
    respond_to do |format|
      if @pyg.update(pyg_params)
        format.html { redirect_to @pyg, notice: "Pyg was successfully updated." }
        format.json { render :show, status: :ok, location: @pyg }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pyg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pygs/1 or /pygs/1.json
  def destroy
    @pyg.destroy!

    respond_to do |format|
      format.html { redirect_to pygs_path, status: :see_other, notice: "Pyg was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pyg
      @pyg = Pyg.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pyg_params
      params.require(:pyg).permit(:user_id, :ingresos_mensual, :gasto_compra, :alquiler_hipoteca, :gastos_utilities, :gastos_seguros, :gastos_transporte, :restaurantes_y_ocio, :cuota_hipoteca, :cuota_coche, :otras_cuotas, :suscripciones, :cuidado_personal, :otros_gastos)
    end
end
