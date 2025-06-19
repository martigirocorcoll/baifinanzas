require "test_helper"

class InfluencersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @influencer = influencers(:one)
  end

  test "should get index" do
    get influencers_url
    assert_response :success
  end

  test "should get new" do
    get new_influencer_url
    assert_response :success
  end

  test "should create influencer" do
    assert_difference("Influencer.count") do
      post influencers_url, params: { influencer: { ac_cdiposit: @influencer.ac_cdiposit, ac_compte: @influencer.ac_compte, ac_curt: @influencer.ac_curt, ac_deute: @influencer.ac_deute, ac_jubil: @influencer.ac_jubil, ac_llarg: @influencer.ac_llarg, name: @influencer.name } }
    end

    assert_redirected_to influencer_url(Influencer.last)
  end

  test "should show influencer" do
    get influencer_url(@influencer)
    assert_response :success
  end

  test "should get edit" do
    get edit_influencer_url(@influencer)
    assert_response :success
  end

  test "should update influencer" do
    patch influencer_url(@influencer), params: { influencer: { ac_cdiposit: @influencer.ac_cdiposit, ac_compte: @influencer.ac_compte, ac_curt: @influencer.ac_curt, ac_deute: @influencer.ac_deute, ac_jubil: @influencer.ac_jubil, ac_llarg: @influencer.ac_llarg, name: @influencer.name } }
    assert_redirected_to influencer_url(@influencer)
  end

  test "should destroy influencer" do
    assert_difference("Influencer.count", -1) do
      delete influencer_url(@influencer)
    end

    assert_redirected_to influencers_url
  end
end
