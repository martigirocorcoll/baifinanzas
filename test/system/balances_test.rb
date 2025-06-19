require "application_system_test_case"

class BalancesTest < ApplicationSystemTestCase
  setup do
    @balance = balances(:one)
  end

  test "visiting the index" do
    visit balances_url
    assert_selector "h1", text: "Balances"
  end

  test "should create balance" do
    visit balances_url
    click_on "New balance"

    fill_in "Deuda tarjeta credito", with: @balance.deuda_tarjeta_credito
    fill_in "Dinero cuenta ahorro depos", with: @balance.dinero_cuenta_ahorro_depos
    fill_in "Dinero cuenta corriente", with: @balance.dinero_cuenta_corriente
    fill_in "Dinero inversiones f", with: @balance.dinero_inversiones_f
    fill_in "Dinero planes pensiones", with: @balance.dinero_planes_pensiones
    fill_in "Hipoteca inmuebles", with: @balance.hipoteca_inmuebles
    fill_in "Otras deudas", with: @balance.otras_deudas
    fill_in "Prestamos coches", with: @balance.prestamos_coches
    fill_in "Prestamos personales", with: @balance.prestamos_personales
    fill_in "User", with: @balance.user_id
    fill_in "Valor coches vehiculos", with: @balance.valor_coches_vehiculos
    fill_in "Valor inmuebles", with: @balance.valor_inmuebles
    fill_in "Valor otros activos", with: @balance.valor_otros_activos
    click_on "Create Balance"

    assert_text "Balance was successfully created"
    click_on "Back"
  end

  test "should update Balance" do
    visit balance_url(@balance)
    click_on "Edit this balance", match: :first

    fill_in "Deuda tarjeta credito", with: @balance.deuda_tarjeta_credito
    fill_in "Dinero cuenta ahorro depos", with: @balance.dinero_cuenta_ahorro_depos
    fill_in "Dinero cuenta corriente", with: @balance.dinero_cuenta_corriente
    fill_in "Dinero inversiones f", with: @balance.dinero_inversiones_f
    fill_in "Dinero planes pensiones", with: @balance.dinero_planes_pensiones
    fill_in "Hipoteca inmuebles", with: @balance.hipoteca_inmuebles
    fill_in "Otras deudas", with: @balance.otras_deudas
    fill_in "Prestamos coches", with: @balance.prestamos_coches
    fill_in "Prestamos personales", with: @balance.prestamos_personales
    fill_in "User", with: @balance.user_id
    fill_in "Valor coches vehiculos", with: @balance.valor_coches_vehiculos
    fill_in "Valor inmuebles", with: @balance.valor_inmuebles
    fill_in "Valor otros activos", with: @balance.valor_otros_activos
    click_on "Update Balance"

    assert_text "Balance was successfully updated"
    click_on "Back"
  end

  test "should destroy Balance" do
    visit balance_url(@balance)
    click_on "Destroy this balance", match: :first

    assert_text "Balance was successfully destroyed"
  end
end
