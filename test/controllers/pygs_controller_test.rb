require "test_helper"

class PygsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pyg = pygs(:one)
  end

  test "should get index" do
    get pygs_url
    assert_response :success
  end

  test "should get new" do
    get new_pyg_url
    assert_response :success
  end

  test "should create pyg" do
    assert_difference("Pyg.count") do
      post pygs_url, params: { pyg: { alquiler_hipoteca: @pyg.alquiler_hipoteca, cuidado_personal: @pyg.cuidado_personal, cuota_coche: @pyg.cuota_coche, cuota_hipoteca: @pyg.cuota_hipoteca, gasto_compra: @pyg.gasto_compra, gastos_seguros: @pyg.gastos_seguros, gastos_transporte: @pyg.gastos_transporte, gastos_utilities: @pyg.gastos_utilities, ingresos_mensual: @pyg.ingresos_mensual, otras_cuotas: @pyg.otras_cuotas, otros_gastos: @pyg.otros_gastos, restaurantes_y_ocio: @pyg.restaurantes_y_ocio, suscripciones: @pyg.suscripciones, user_id: @pyg.user_id } }
    end

    assert_redirected_to pyg_url(Pyg.last)
  end

  test "should show pyg" do
    get pyg_url(@pyg)
    assert_response :success
  end

  test "should get edit" do
    get edit_pyg_url(@pyg)
    assert_response :success
  end

  test "should update pyg" do
    patch pyg_url(@pyg), params: { pyg: { alquiler_hipoteca: @pyg.alquiler_hipoteca, cuidado_personal: @pyg.cuidado_personal, cuota_coche: @pyg.cuota_coche, cuota_hipoteca: @pyg.cuota_hipoteca, gasto_compra: @pyg.gasto_compra, gastos_seguros: @pyg.gastos_seguros, gastos_transporte: @pyg.gastos_transporte, gastos_utilities: @pyg.gastos_utilities, ingresos_mensual: @pyg.ingresos_mensual, otras_cuotas: @pyg.otras_cuotas, otros_gastos: @pyg.otros_gastos, restaurantes_y_ocio: @pyg.restaurantes_y_ocio, suscripciones: @pyg.suscripciones, user_id: @pyg.user_id } }
    assert_redirected_to pyg_url(@pyg)
  end

  test "should destroy pyg" do
    assert_difference("Pyg.count", -1) do
      delete pyg_url(@pyg)
    end

    assert_redirected_to pygs_url
  end
end
