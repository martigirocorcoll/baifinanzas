require "application_system_test_case"

class PygsTest < ApplicationSystemTestCase
  setup do
    @pyg = pygs(:one)
  end

  test "visiting the index" do
    visit pygs_url
    assert_selector "h1", text: "Pygs"
  end

  test "should create pyg" do
    visit pygs_url
    click_on "New pyg"

    fill_in "Alquiler hipoteca", with: @pyg.alquiler_hipoteca
    fill_in "Cuidado personal", with: @pyg.cuidado_personal
    fill_in "Cuota coche", with: @pyg.cuota_coche
    fill_in "Cuota hipoteca", with: @pyg.cuota_hipoteca
    fill_in "Gasto compra", with: @pyg.gasto_compra
    fill_in "Gastos seguros", with: @pyg.gastos_seguros
    fill_in "Gastos transporte", with: @pyg.gastos_transporte
    fill_in "Gastos utilities", with: @pyg.gastos_utilities
    fill_in "Ingresos mensual", with: @pyg.ingresos_mensual
    fill_in "Otras cuotas", with: @pyg.otras_cuotas
    fill_in "Otros gastos", with: @pyg.otros_gastos
    fill_in "Restaurantes y ocio", with: @pyg.restaurantes_y_ocio
    fill_in "Suscripciones", with: @pyg.suscripciones
    fill_in "User", with: @pyg.user_id
    click_on "Create Pyg"

    assert_text "Pyg was successfully created"
    click_on "Back"
  end

  test "should update Pyg" do
    visit pyg_url(@pyg)
    click_on "Edit this pyg", match: :first

    fill_in "Alquiler hipoteca", with: @pyg.alquiler_hipoteca
    fill_in "Cuidado personal", with: @pyg.cuidado_personal
    fill_in "Cuota coche", with: @pyg.cuota_coche
    fill_in "Cuota hipoteca", with: @pyg.cuota_hipoteca
    fill_in "Gasto compra", with: @pyg.gasto_compra
    fill_in "Gastos seguros", with: @pyg.gastos_seguros
    fill_in "Gastos transporte", with: @pyg.gastos_transporte
    fill_in "Gastos utilities", with: @pyg.gastos_utilities
    fill_in "Ingresos mensual", with: @pyg.ingresos_mensual
    fill_in "Otras cuotas", with: @pyg.otras_cuotas
    fill_in "Otros gastos", with: @pyg.otros_gastos
    fill_in "Restaurantes y ocio", with: @pyg.restaurantes_y_ocio
    fill_in "Suscripciones", with: @pyg.suscripciones
    fill_in "User", with: @pyg.user_id
    click_on "Update Pyg"

    assert_text "Pyg was successfully updated"
    click_on "Back"
  end

  test "should destroy Pyg" do
    visit pyg_url(@pyg)
    click_on "Destroy this pyg", match: :first

    assert_text "Pyg was successfully destroyed"
  end
end
