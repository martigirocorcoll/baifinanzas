class BalancesController < ApplicationController
  layout 'app'
  before_action :authenticate_user!
  before_action :set_balance, only: %i[show edit update]

  def show
  end

  def new
    @balance = current_user.build_balance
  end

  def create
    @balance = current_user.build_balance(balance_params)
    if @balance.save
      current_user.update_column(:balance_completed, true)
      redirect_to onboarding_processing_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @balance.update(balance_params)
      current_user.update_column(:balance_completed, true)
      redirect_to onboarding_processing_path, notice: t('controllers.balances.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_balance
    @balance = current_user.balance || current_user.build_balance
  end

  def balance_params
    params.require(:balance).permit(
      :valor_inmuebles,
      :dinero_cuenta_corriente,
      :dinero_cuenta_ahorro_depos,
      :dinero_inversiones_f,
      :dinero_planes_pensiones,
      :valor_coches_vehiculos,
      :valor_otros_activos,
      :hipoteca_inmuebles,
      :deuda_tarjeta_credito,
      :prestamos_personales,
      :prestamos_coches,
      :otras_deudas
    )
  end
end
