class PygsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pyg, only: %i[show edit update]

  # GET /pyg
  def show
  end

  # GET /pyg/new
  def new
    # build_pyg deja @pyg.user_id = current_user.id
    @pyg = current_user.build_pyg
  end

  # POST /pyg
  def create
    @pyg = current_user.build_pyg(pyg_params)
    if @pyg.save
      # Redirect to balance if not filled yet (onboarding flow)
      balance_has_data = current_user.balance&.has_data?

      if !balance_has_data
        redirect_to new_balance_path, notice: "¡Excelente! Paso 1 completado. Ahora vamos con tu balance patrimonial."
      else
        redirect_to authenticated_root_path, notice: "PYG actualizado correctamente."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /pyg/edit
  def edit
  end

  # PATCH/PUT /pyg
  def update
    if @pyg.update(pyg_params)
      # Always show processing screen when updating financial data
      redirect_to onboarding_processing_path, notice: "PYG actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_pyg
    # si ya existe, lo carga; si no, construye uno nuevo (pero no guarda)
    @pyg = current_user.pyg || current_user.build_pyg
  end

  def pyg_params
    params.require(:pyg).permit(
      :ingresos_mensual,
      :gasto_compra,
      :alquiler_hipoteca,
      :gastos_utilities,
      :gastos_seguros,
      :gastos_transporte,
      :restaurantes_y_ocio,
      :cuota_hipoteca,
      :cuota_coche,
      :otras_cuotas,
      :suscripciones,
      :cuidado_personal,
      :otros_gastos
    )
  end
end
