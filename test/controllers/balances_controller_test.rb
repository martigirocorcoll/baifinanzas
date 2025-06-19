require "test_helper"

class BalancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @balance = balances(:one)
  end

  test "should get index" do
    get balances_url
    assert_response :success
  end

  test "should get new" do
    get new_balance_url
    assert_response :success
  end

  test "should create balance" do
    assert_difference("Balance.count") do
      post balances_url, params: { balance: { deuda_tarjeta_credito: @balance.deuda_tarjeta_credito, dinero_cuenta_ahorro_depos: @balance.dinero_cuenta_ahorro_depos, dinero_cuenta_corriente: @balance.dinero_cuenta_corriente, dinero_inversiones_f: @balance.dinero_inversiones_f, dinero_planes_pensiones: @balance.dinero_planes_pensiones, hipoteca_inmuebles: @balance.hipoteca_inmuebles, otras_deudas: @balance.otras_deudas, prestamos_coches: @balance.prestamos_coches, prestamos_personales: @balance.prestamos_personales, user_id: @balance.user_id, valor_coches_vehiculos: @balance.valor_coches_vehiculos, valor_inmuebles: @balance.valor_inmuebles, valor_otros_activos: @balance.valor_otros_activos } }
    end

    assert_redirected_to balance_url(Balance.last)
  end

  test "should show balance" do
    get balance_url(@balance)
    assert_response :success
  end

  test "should get edit" do
    get edit_balance_url(@balance)
    assert_response :success
  end

  test "should update balance" do
    patch balance_url(@balance), params: { balance: { deuda_tarjeta_credito: @balance.deuda_tarjeta_credito, dinero_cuenta_ahorro_depos: @balance.dinero_cuenta_ahorro_depos, dinero_cuenta_corriente: @balance.dinero_cuenta_corriente, dinero_inversiones_f: @balance.dinero_inversiones_f, dinero_planes_pensiones: @balance.dinero_planes_pensiones, hipoteca_inmuebles: @balance.hipoteca_inmuebles, otras_deudas: @balance.otras_deudas, prestamos_coches: @balance.prestamos_coches, prestamos_personales: @balance.prestamos_personales, user_id: @balance.user_id, valor_coches_vehiculos: @balance.valor_coches_vehiculos, valor_inmuebles: @balance.valor_inmuebles, valor_otros_activos: @balance.valor_otros_activos } }
    assert_redirected_to balance_url(@balance)
  end

  test "should destroy balance" do
    assert_difference("Balance.count", -1) do
      delete balance_url(@balance)
    end

    assert_redirected_to balances_url
  end
end
