require "application_system_test_case"

class ObjectivesTest < ApplicationSystemTestCase
  setup do
    @objective = objectives(:one)
  end

  test "visiting the index" do
    visit objectives_url
    assert_selector "h1", text: "Objectives"
  end

  test "should create objective" do
    visit objectives_url
    click_on "New objective"

    fill_in "Description", with: @objective.description
    fill_in "Status", with: @objective.status
    fill_in "Target amount", with: @objective.target_amount
    fill_in "Target date", with: @objective.target_date
    fill_in "Title", with: @objective.title
    fill_in "User", with: @objective.user_id
    click_on "Create Objective"

    assert_text "Objective was successfully created"
    click_on "Back"
  end

  test "should update Objective" do
    visit objective_url(@objective)
    click_on "Edit this objective", match: :first

    fill_in "Description", with: @objective.description
    fill_in "Status", with: @objective.status
    fill_in "Target amount", with: @objective.target_amount
    fill_in "Target date", with: @objective.target_date
    fill_in "Title", with: @objective.title
    fill_in "User", with: @objective.user_id
    click_on "Update Objective"

    assert_text "Objective was successfully updated"
    click_on "Back"
  end

  test "should destroy Objective" do
    visit objective_url(@objective)
    click_on "Destroy this objective", match: :first

    assert_text "Objective was successfully destroyed"
  end
end
