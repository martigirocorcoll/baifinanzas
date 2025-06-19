require "application_system_test_case"

class InfluencersTest < ApplicationSystemTestCase
  setup do
    @influencer = influencers(:one)
  end

  test "visiting the index" do
    visit influencers_url
    assert_selector "h1", text: "Influencers"
  end

  test "should create influencer" do
    visit influencers_url
    click_on "New influencer"

    fill_in "Ac cdiposit", with: @influencer.ac_cdiposit
    fill_in "Ac compte", with: @influencer.ac_compte
    fill_in "Ac curt", with: @influencer.ac_curt
    fill_in "Ac deute", with: @influencer.ac_deute
    fill_in "Ac jubil", with: @influencer.ac_jubil
    fill_in "Ac llarg", with: @influencer.ac_llarg
    fill_in "Name", with: @influencer.name
    click_on "Create Influencer"

    assert_text "Influencer was successfully created"
    click_on "Back"
  end

  test "should update Influencer" do
    visit influencer_url(@influencer)
    click_on "Edit this influencer", match: :first

    fill_in "Ac cdiposit", with: @influencer.ac_cdiposit
    fill_in "Ac compte", with: @influencer.ac_compte
    fill_in "Ac curt", with: @influencer.ac_curt
    fill_in "Ac deute", with: @influencer.ac_deute
    fill_in "Ac jubil", with: @influencer.ac_jubil
    fill_in "Ac llarg", with: @influencer.ac_llarg
    fill_in "Name", with: @influencer.name
    click_on "Update Influencer"

    assert_text "Influencer was successfully updated"
    click_on "Back"
  end

  test "should destroy Influencer" do
    visit influencer_url(@influencer)
    click_on "Destroy this influencer", match: :first

    assert_text "Influencer was successfully destroyed"
  end
end
