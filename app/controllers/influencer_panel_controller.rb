class InfluencerPanelController < ApplicationController
  before_action :require_influencer!
  layout "influencer"

  def dashboard
    @influencer = current_user.influencer_profile
    @referred_users_count = @influencer.users.count
    @referral_link = "#{request.protocol}#{request.host_with_port}/?ref=#{@influencer.code}"

    # Count configured links and videos
    link_fields = [:ac_compte, :ac_cdiposit, :ac_saving, :ac_deute, :ac_mortgage,
                   :ac_curt, :ac_llarg, :ac_jubil, :ac_portfolio, :ac_fiscal]
    @configured_links = link_fields.count { |f| @influencer.send(f).present? }

    video_fields = [:video_compte, :video_cdiposit, :video_diposit, :video_saving, :video_deute,
                    :video_mortgage, :video_curt, :video_llarg, :video_jubil, :video_portfolio, :video_fiscal]
    @configured_videos = video_fields.count { |f| @influencer.send(f).present? }
  end

  def links
    @influencer = current_user.influencer_profile
  end

  def update_links
    @influencer = current_user.influencer_profile
    if @influencer.update(link_params)
      redirect_to influencer_links_path, notice: "Enlaces actualizados correctamente."
    else
      render :links, status: :unprocessable_entity
    end
  end

  def videos
    @influencer = current_user.influencer_profile
  end

  def update_videos
    @influencer = current_user.influencer_profile
    if @influencer.update(video_params)
      redirect_to influencer_videos_path, notice: "Videos actualizados correctamente."
    else
      render :videos, status: :unprocessable_entity
    end
  end

  private

  def require_influencer!
    unless current_user&.influencer?
      redirect_to root_path, alert: "No tienes permisos para acceder a esta pagina."
    end
  end

  def link_params
    params.require(:influencer).permit(
      :ac_compte, :ac_cdiposit, :ac_saving, :ac_deute, :ac_mortgage,
      :ac_curt, :ac_llarg, :ac_jubil, :ac_portfolio, :ac_fiscal
    )
  end

  def video_params
    params.require(:influencer).permit(
      :youtube_url,
      :video_compte, :video_cdiposit, :video_diposit, :video_saving, :video_deute,
      :video_mortgage, :video_curt, :video_llarg, :video_jubil, :video_portfolio, :video_fiscal
    )
  end
end
