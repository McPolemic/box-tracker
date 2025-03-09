require "application_system_test_case"

class BoxGroupsTest < ApplicationSystemTestCase
  setup do
    @box_group = box_groups(:one)
  end

  test "visiting the index" do
    visit box_groups_url
    assert_selector "h1", text: "Box groups"
  end

  test "should create box group" do
    visit box_groups_url
    click_on "New box group"

    fill_in "Display name", with: @box_group.display_name
    fill_in "Notes", with: @box_group.notes
    click_on "Create Box group"

    assert_text "Box group was successfully created"
    click_on "Back"
  end

  test "should update Box group" do
    visit box_group_url(@box_group)
    click_on "Edit this box group", match: :first

    fill_in "Display name", with: @box_group.display_name
    fill_in "Notes", with: @box_group.notes
    click_on "Update Box group"

    assert_text "Box group was successfully updated"
    click_on "Back"
  end

  test "should destroy Box group" do
    visit box_group_url(@box_group)
    click_on "Destroy this box group", match: :first

    assert_text "Box group was successfully destroyed"
  end
end
