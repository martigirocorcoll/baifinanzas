class HomeController < ApplicationController
  layout 'app'

  before_action :check_onboarding

  def index
    if session.delete(:objective_processing)
      return render 'objectives/processing'
    end

    @user = current_user
    @objective = current_user.objectives.first
    @new_objective = current_user.objectives.new unless @objective

    if @objective
      load_objective_data
    end
  end

  private

  def check_onboarding
    unless current_user.has_basic_financial_data?
      redirect_to onboarding_welcome_path and return
    end
  end

  def load_objective_data
    @inv_recommendation = @objective.investment_recommendation
    @inv_slug = @inv_recommendation.dasherize
    @annual_return = @objective.annual_return_rate
    @monthly_needed = @objective.monthly_savings_needed
    @progress_pct = @objective.current_progress_percentage

    # Investment recommendation display info
    @inv_display = investment_display_info(@inv_recommendation)

    # Video from influencer
    influencer = current_user.influencer || Influencer.find_by(default: true) || Influencer.first
    @video_url = current_user.get_video_url(@inv_slug) if influencer

    # Affiliate link
    @affiliate_link = current_user.get_affiliate_link(@inv_recommendation.gsub('ac_', ''))
  end

  def investment_display_info(rec_key)
    case rec_key
    when "ac_diposit"
      { icon: "bi-piggy-bank", return_label: "~1.5%" }
    when "ac_curt"
      { icon: "bi-graph-up", return_label: "~3%" }
    when "ac_llarg"
      { icon: "bi-graph-up-arrow", return_label: "~8%" }
    when "ac_jubil"
      { icon: "bi-piggy-bank-fill", return_label: "~8%" }
    else
      { icon: "bi-graph-up", return_label: "" }
    end
  end
end
