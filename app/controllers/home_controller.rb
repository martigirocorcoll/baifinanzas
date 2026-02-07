class HomeController < ApplicationController
  layout 'app'

  before_action :check_onboarding

  def index
    @user = current_user
    @pyg = current_user.pyg
    @balance = current_user.balance
    @objectives = current_user.objectives.order(:target_date)

    # Financial health data
    load_financial_health_data

    # Action plan data
    load_action_plan_data

    # Objectives data
    load_objectives_data

    # Chart data
    load_chart_data
  end

  private

  def check_onboarding
    # Redirect to onboarding if user hasn't completed basic data
    unless current_user.has_basic_financial_data?
      redirect_to onboarding_basic_path and return
    end
  end

  def load_financial_health_data
    @financial_level = {
      key: current_user.financial_health_level_key,
      number: current_user.financial_health_level_number,
      name: t("financial.levels.#{current_user.financial_health_level_key}.name"),
      icon: t("financial.levels.#{current_user.financial_health_level_key}.bootstrap_icon"),
      description: t("financial.levels.#{current_user.financial_health_level_key}.description")
    }

    @monthly_cash_flow = current_user.monthly_cash_flow
    @net_worth = current_user.net_worth

    # Progress to next level
    @next_level = calculate_next_level_info
  end

  def load_action_plan_data
    full_plan = current_user.action_plan
    @recommendation_actions = full_plan.select { |a| a[:type] == 'recommendation' }

    # Carousel: completed first (left), then uncompleted (right)
    completed = @recommendation_actions.select { |a| a[:completed] }
    uncompleted = @recommendation_actions.reject { |a| a[:completed] }
    @carousel_actions = completed + uncompleted
    @first_uncompleted_index = completed.length

    @completed_count = completed.length
    @total_count = @recommendation_actions.count
    @progress_percentage = @total_count > 0 ? ((@completed_count.to_f / @total_count) * 100).round(0) : 0
    @can_invest = current_user.can_invest_in_objectives?
  end

  def load_objectives_data
    @active_objectives = current_user.objectives.order(:target_date).select(&:valid_for_display?)
    @new_objective = current_user.objectives.build

    # Calculate savings capacity
    total_committed = @active_objectives.sum { |obj| obj.monthly_savings_needed }
    @savings_capacity = {
      available: @monthly_cash_flow,
      committed: total_committed,
      remaining: @monthly_cash_flow - total_committed
    }
  end

  def load_chart_data
    @income = current_user.monthly_income
    @expenses = current_user.monthly_expenses
    @total_assets = current_user.total_assets
    @total_debts = current_user.total_debt
  end

  def calculate_next_level_info
    level_key = current_user.financial_health_level_key

    next_level_map = {
      critical: :emergency_fund,
      emergency_fund: :paying_debt,
      paying_debt: :stable,
      stable: :growth,
      growth: :financial_freedom,
      financial_freedom: nil
    }

    next_level_key = next_level_map[level_key]

    return nil if next_level_key.nil?

    {
      key: next_level_key,
      name: t("financial.levels.#{next_level_key}.name"),
      requirements: get_level_requirements(level_key)
    }
  end

  def get_level_requirements(current_level_key)
    case current_level_key
    when :critical
      [{
        text: t('financial.next_level.positive_cash_flow'),
        completed: @monthly_cash_flow > 0
      }]
    when :emergency_fund
      [{
        text: t('financial.next_level.emergency_2_months'),
        completed: current_user.has_partial_emergency_fund?
      }]
    when :paying_debt
      [{
        text: t('financial.next_level.expensive_debt_under_40'),
        completed: current_user.expensive_debt_ratio < 0.4
      }]
    when :stable
      [{
        text: t('financial.next_level.net_worth_2_years'),
        completed: @net_worth >= (current_user.annual_income * 2)
      }]
    when :growth
      [{
        text: t('financial.next_level.investment_income_covers_expenses'),
        completed: current_user.has_financial_freedom?
      }]
    else
      []
    end
  end
end
