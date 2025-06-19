class InfluencersController < ApplicationController
  before_action :set_influencer, only: %i[ show edit update destroy ]

  # GET /influencers or /influencers.json
  def index
    @influencers = Influencer.all
  end

  # GET /influencers/1 or /influencers/1.json
  def show
  end

  # GET /influencers/new
  def new
    @influencer = Influencer.new
  end

  # GET /influencers/1/edit
  def edit
  end

  # POST /influencers or /influencers.json
  def create
    @influencer = Influencer.new(influencer_params)

    respond_to do |format|
      if @influencer.save
        format.html { redirect_to @influencer, notice: "Influencer was successfully created." }
        format.json { render :show, status: :created, location: @influencer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @influencer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /influencers/1 or /influencers/1.json
  def update
    respond_to do |format|
      if @influencer.update(influencer_params)
        format.html { redirect_to @influencer, notice: "Influencer was successfully updated." }
        format.json { render :show, status: :ok, location: @influencer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @influencer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /influencers/1 or /influencers/1.json
  def destroy
    @influencer.destroy!

    respond_to do |format|
      format.html { redirect_to influencers_path, status: :see_other, notice: "Influencer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_influencer
      @influencer = Influencer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def influencer_params
      params.require(:influencer).permit(:name, :ac_compte, :ac_cdiposit, :ac_curt, :ac_llarg, :ac_deute, :ac_jubil)
    end
end
