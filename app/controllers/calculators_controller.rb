class CalculatorsController < ApplicationController
  layout 'app'

  def index
    @calculator_categories = [
      {
        title: t('calculators.category_savings_investment'),
        calculators: [
          { key: 'compound_interest', title: t('calculators.compound_interest.title'), description: t('calculators.compound_interest.description'), icon: 'bi-graph-up-arrow', path: calculator_compound_interest_path },
          { key: 'investment_goal', title: t('calculators.investment_goal.title'), description: t('calculators.investment_goal.description'), icon: 'bi-bullseye', path: calculator_investment_goal_path },
          { key: 'investment_returns', title: t('calculators.investment_returns.title'), description: t('calculators.investment_returns.description'), icon: 'bi-percent', path: calculator_investment_returns_path }
        ]
      },
      {
        title: t('calculators.category_housing_debt'),
        calculators: [
          { key: 'mortgage', title: t('calculators.mortgage.title'), description: t('calculators.mortgage.description'), icon: 'bi-house-door', path: calculator_mortgage_path },
          { key: 'early_repayment', title: t('calculators.early_repayment.title'), description: t('calculators.early_repayment.description'), icon: 'bi-cash-stack', path: calculator_early_repayment_path }
        ]
      },
      {
        title: t('calculators.category_financial_security'),
        calculators: [
          { key: 'emergency_fund', title: t('calculators.emergency_fund.title'), description: t('calculators.emergency_fund.description'), icon: 'bi-shield-check', path: calculator_emergency_fund_path },
          { key: 'financial_freedom', title: t('calculators.financial_freedom.title'), description: t('calculators.financial_freedom.description'), icon: 'bi-sun', path: calculator_financial_freedom_path }
        ]
      }
    ]
  end

  def compound_interest
    @title = t('calculators.compound_interest.title')
    load_user_financial_context
  end

  def mortgage
    @title = t('calculators.mortgage.title')
    load_user_financial_context
  end

  def emergency_fund
    @title = t('calculators.emergency_fund.title')
    load_user_financial_context

    # Pre-fill with user data if available
    if current_user.pyg.present?
      @user_expenses = current_user.monthly_expenses
      @expense_breakdown = get_expense_breakdown
    end

    if current_user.balance.present?
      @user_savings = current_user.liquid_assets
    end
  end

  def financial_freedom
    @title = t('calculators.financial_freedom.title')
    load_user_financial_context

    # Pre-fill with user data if available
    if current_user.pyg.present?
      @user_expenses = current_user.monthly_expenses
    end

    if current_user.balance.present?
      @user_net_worth = current_user.net_worth
    end
  end

  def investment_goal
    @title = t('calculators.investment_goal.title')
    load_user_financial_context

    # Pre-fill with user data if available
    if current_user.balance.present?
      @user_savings = current_user.liquid_assets
    end
  end

  def early_repayment
    @title = t('calculators.early_repayment.title')
    load_user_financial_context

    # Pre-fill with user data if available
    if current_user.balance.present?
      @user_mortgage = current_user.balance.hipoteca_inmuebles || 0
    end

    if current_user.pyg.present?
      @user_cash_flow = current_user.monthly_cash_flow
    end
  end

  def investment_returns
    @title = t('calculators.investment_returns.title')
    load_user_financial_context
  end

  private

  def load_user_financial_context
    @has_pyg = current_user.pyg.present? && current_user.pyg.ingresos_mensual.present?
    @has_balance = current_user.balance.present? && current_user.total_assets > 0
  end

  def get_expense_breakdown
    return {} unless current_user.pyg.present?

    pyg = current_user.pyg
    {
      vivienda: pyg.alquiler_hipoteca || 0,
      compra: pyg.gasto_compra || 0,
      transporte: pyg.gastos_transporte || 0,
      ocio: pyg.restaurantes_y_ocio || 0,
      utilities: pyg.gastos_utilities || 0,
      seguros: pyg.gastos_seguros || 0,
      otros: pyg.otros_gastos || 0
    }
  end
end
